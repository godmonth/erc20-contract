pragma solidity ^0.4.18;

import '../ownership/HasName.sol';
import '../ownership/Ownable.sol';
import '../lifecycle/Pausable.sol';
import '../ownership/HasMintableToken.sol';
import '../ownership/WalletUsage.sol';

contract BaseSale is Pausable, HasMintableToken, WalletUsage, HasName {
    using SafeMath for uint256;

    /**
     * 总共可销售token
     */
    uint256 public tokenTotal;

    /**
     * 已出售token
     */
    uint256 public tokenSold;

    // amount of raised money in wei
    uint256 public weiRaised;

    mapping(address => uint256) public purchasedTokens;

    mapping(address => uint256) public costs;

    /**
     * event for token purchase logging
     * @param beneficiary who got the tokens
     * @param value weis paid for purchase
     * @param amount amount of tokens purchased
     */
    event TokenPurchased(address indexed beneficiary, uint256 value, uint256 amount);

    function getRate(address beneficiary) internal returns (uint256);

    function getTokenOnSale() view public returns (uint256){
        return tokenTotal.sub(tokenSold);
    }

    function validatePurchasedValue(address beneficiary, uint256 tokenAmount) internal {
        //数据校验
        require(beneficiary != address(0));
        require(tokenAmount > 0);
        require(getTokenOnSale() >= tokenAmount);
    }

    function updatePurchasedValue(address beneficiary, uint256 weiAmount, uint256 tokenAmount) internal {

        //修改计数
        purchasedTokens[beneficiary] = purchasedTokens[beneficiary].add(tokenAmount);
        tokenSold = tokenSold.add(tokenAmount);
        if (weiAmount > 0) {
            costs[beneficiary] = costs[beneficiary].add(weiAmount);
            weiRaised = weiRaised.add(weiAmount);
        }
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

    function setTokenTotal(uint256 _tokenTotal) public onlyOwner {
        require(_tokenTotal >= tokenSold);
        tokenTotal = _tokenTotal;
    }
}
