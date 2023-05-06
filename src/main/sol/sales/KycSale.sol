pragma solidity ^0.4.18;


import './BaseSale.sol';
import './Kyc.sol';
import './OneRate.sol';

contract KycSale is BaseSale, OneRate {
    // The kyc
    Kyc public kyc;

    function KycSale(string _name, address walletAddress, address tokenAddress, address kycAddress,
        uint256 _tokenTotal, uint256 _rate) public {
        setName(_name);
        setWallet(walletAddress);
        setToken(tokenAddress);
        setKyc(kycAddress);

        require(_tokenTotal > 0);
        tokenTotal = _tokenTotal;

        require(_rate > 0);
        rate = _rate;

        paused = true;
    }
    // fallback function can be used to buy tokens
    function() whenNotPaused external payable {

        //数据校验
        address beneficiary = msg.sender;

        uint256 weiAmount = msg.value;

        uint256 tokenAmount = weiAmount.mul(getRate(beneficiary));

        validatePurchasedValue(beneficiary, tokenAmount);

        //修改值
        updatePurchasedValue(beneficiary, weiAmount, tokenAmount);

        //变更钱与币
        if (!keepEth) {
            wallet.transfer(weiAmount);
        }
        token.mint(beneficiary, tokenAmount);

        //发送事件
        TokenPurchased(this, weiAmount, tokenAmount);
    }

    function validatePurchasedValue(address beneficiary, uint256 tokenAmount) internal {
        require(address(kyc) == address(0) || kyc.customers(beneficiary));
        super.validatePurchasedValue(beneficiary, tokenAmount);
    }

    function setKyc(address kycAddress) public onlyOwner {
        kyc = Kyc(kycAddress);
    }


}
