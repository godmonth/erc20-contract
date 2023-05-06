pragma solidity ^0.4.18;

import '../ownership/OperatorPermission.sol';
import '../ownership/HasWallet.sol';

import '../token/MintableToken.sol';
import './Kyc.sol';

import '../math/SafeMath.sol';
import '../token/SafeMint.sol';
import '../token/SafeSuperTransfer.sol';

contract AbstAsset is OperatorPermission, HasWallet {
    using SafeMath for uint256;
    using SafeSuperTransfer for MintableToken;
    using SafeMint for MintableToken;

    struct Asset {
        uint256 id;

        //资产编号
        string code;

        uint256 tokenAmount;
        uint256 expectedCash;
        uint256 actualCash;
        uint256 repayTimestamp;
        AssetStatus status;
    }
    enum AssetStatus {INVALID, CREATED, CLEARED}

    Asset[] public assets;

    bool public submitted;

    //asset.id->array.offset
    mapping(uint256 => uint256) public idIndex;

    event assetUpdated(uint256 indexed assetId, AssetStatus status);

    struct Settlement {
        address beneficiary;
        uint256 token;
        uint256 cash;
    }

    Settlement[] public settlements;

    uint256 public minimumSettleAmount = 1;

    MintableToken public tokenContract;


    Kyc public kyc;

    //当前可结算
    uint256 public settleableToken;
    uint256 public settleableCash;


    //预估净值
    uint256 public submittedRateEnumerator;
    uint256 public submittedRateDenominator = 10000;

    //当前净值
    uint256 public settleableRateEnumerator;
    uint256 public settleableRateDenominator = submittedRateDenominator;

    //已登记
    uint256 public totalSubmittedToken;
    uint256 public totalSubmittedCash;

    //已清偿
    uint256 public totalClearedToken;
    uint256 public totalClearedCash;

    //已结算
    uint256 public totalSettledToken;
    uint256 public totalSettledCash;


    function AbstAsset(address _tokenContract, address kycAddress) public {
        tokenContract = MintableToken(_tokenContract);
        setKyc(kycAddress);
        setWallet(msg.sender);
        assets.push(Asset(0, "", 0, 0, 0, 0, AssetStatus.INVALID));
        settlements.push(Settlement(0, 0, 0));
    }

    function setKyc(address kycAddress) public onlyOwner {
        kyc = Kyc(kycAddress);
    }

    function setMinimumSettleAmount(uint256 _minimumSettleAmount) public onlyOwner {
        minimumSettleAmount = _minimumSettleAmount;
    }

    function submitAsset(uint256 id, string code, uint256 tokenAmount, uint256 cash, uint256 repayTimestamp)
    onlyOperator public {
        //校验
        require(id > 0);
        require(idIndex[id] == 0);
        require(repayTimestamp > 0);
        require(!submitted);

        //增加资产条目
        uint256 offset = assets.push(Asset(id, code, tokenAmount, cash, 0, repayTimestamp, AssetStatus.CREATED)) - 1;
        idIndex[id] = offset;

        //触发事件
        assetUpdated(id, AssetStatus.CREATED);

        //铸币
        tokenContract.safeMint(wallet, tokenAmount);

        //统计
        totalSubmittedToken = totalSubmittedToken.add(tokenAmount);
        totalSubmittedCash = totalSubmittedCash.add(cash);

    }


    function finishSubmit() public onlyOwner {
        submitted = true;
        submittedRateEnumerator = totalSubmittedCash.mul(submittedRateDenominator).div(totalSubmittedToken);
        settleableRateEnumerator = submittedRateEnumerator;
    }

    function batchClearAsset(uint256[] id, uint256[] actualCash) onlyOperator
    public {
        for (uint256 i = 0; i < id.length; i++) {
            clearAsset(id[i], actualCash[i]);
        }
    }

    function clearAsset(uint256 id, uint256 actualCash) onlyOperator
    public {
        //校验
        require(submitted);
        require(id > 0);
        require(idIndex[id] > 0);
        uint256 offset = idIndex[id];

        //查询变更资产状态到已清算
        Asset asset = innerGetAsset(offset);
        AssetStatus[] memory exptectedStatusArray = new  AssetStatus[](1);
        exptectedStatusArray[0] = AssetStatus.CREATED;
        checkAndChangeStatus(asset, exptectedStatusArray, AssetStatus.CLEARED);

        //设置资产实际还款金额
        asset.actualCash = actualCash;

        //触发事件
        assetUpdated(id, AssetStatus.CLEARED);

        //统计
        totalClearedToken = totalClearedToken.add(asset.tokenAmount);
        totalClearedCash = totalClearedCash.add(actualCash);

        //可结算
        settleableToken = settleableToken.add(asset.tokenAmount);
        settleableCash = settleableCash.add(actualCash);

        settleableRateEnumerator = settleableCash.mul(settleableRateDenominator).div(settleableToken);
    }

    function permitSettleToken(address beneficiary) public view returns (bool){
        return kyc.permit(beneficiary);
    }


    function calculateCash(uint256 token) public view returns (uint256 calculatedCash){
        //折算的现金
        calculatedCash = token.mul(settleableRateEnumerator).div(settleableRateDenominator);
    }

    function settleToken(uint256 token, uint256 inputCash) public {
        settleTokenToBeneficiary(msg.sender, token, inputCash);
    }

    function settleTokenToBeneficiary(address beneficiary, uint256 token, uint256 inputCash) public {
        //校验
        //防钓鱼
        require(tx.origin == msg.sender);
        address tokenHolder = msg.sender;

        //校验kyc
        require(kyc.permit(beneficiary));

        //校验余额
        require(token > 0);
        require(tokenContract.balanceOf(tokenHolder) >= token);
        require(token <= settleableToken);

        //折算的现金
        uint256 calculatedCash = calculateCash(token);

        require(calculatedCash == inputCash);

        //校验现金
        require(calculatedCash <= settleableCash);

        //从tx.origin转账到合约自己
        tokenContract.safeSuperTransfer(this, token);

        //销毁合约自己的代币
        tokenContract.safeBurn(token);

        //事件
        settled(beneficiary, token, calculatedCash);
        settlements.push(Settlement(beneficiary, token, calculatedCash));

        //减少结算
        settleableToken = settleableToken.sub(token);
        settleableCash = settleableCash.sub(calculatedCash);

        //统计
        totalSettledToken = totalSettledToken.add(token);
        totalSettledCash = totalSettledCash.add(calculatedCash);

    }

    event settled(address beneficiary, uint256 token, uint256 cash);

    function innerGetAsset(uint256 offset) internal returns (Asset storage asset){
        require(offset > 0);
        asset = assets[offset];
        require(asset.id > 0);
    }

    function checkStatus(AssetStatus inputStatus, AssetStatus[] expectedStatusArray) internal returns (bool){
        for (uint256 i = 0; i < expectedStatusArray.length; i++) {
            if (inputStatus == expectedStatusArray[i]) {
                return true;
            }
        }
        return false;
    }

    function checkAndChangeStatus(Asset  storage asset, AssetStatus[] fromStatusArray, AssetStatus nextStatus)
    internal {
        require(checkStatus(asset.status, fromStatusArray));
        justChangeStatus(asset, nextStatus);
    }

    function justChangeStatus(Asset  storage asset, AssetStatus nextStatus) internal {
        //状态机跃迁
        asset.status = nextStatus;
        assetUpdated(asset.id, nextStatus);
    }

    function getAssetArrayLength() public view returns (uint256){
        return assets.length;
    }

    function getSettlementArrayLength() public view returns (uint256){
        return settlements.length;
    }

    function getSubmittedRate() public view returns (uint256 _submittedRateEnumerator, uint256
        _submittedRateDenominator){
        return (submittedRateEnumerator, submittedRateDenominator);
    }

    function getSettleableRate() public view returns (uint256 _settleableRateEnumerator, uint256
        _settleableRateDenominator){
        return (settleableRateEnumerator, settleableRateDenominator);
    }

}