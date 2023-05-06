pragma solidity ^0.4.18;

import '../token/SafeERC20.sol';
import './BaseSale.sol';

contract Phase2Sale is BaseSale {

    using SafeERC20 for MintableToken;

    mapping(address => uint256) public withdrawedTokens;

    event TokenWithdrawed(address indexed beneficiary, uint256 amount);

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

        //发送事件
        TokenPurchased(this, weiAmount, tokenAmount);
    }

    function getWithdrawableAmount(address beneficiary) public view returns (uint256){
        return purchasedTokens[beneficiary].sub(withdrawedTokens[beneficiary]);
    }

    function validateWithdrawValue(address beneficiary, uint256 tokenAmount) internal {
        require(beneficiary != address(0));
        require(tokenAmount > 0 && getWithdrawableAmount(beneficiary) >= tokenAmount);
    }

    function withdrawInternal(address beneficiary, uint256 tokenAmount) internal {
        //数据校验
        validateWithdrawValue(beneficiary, tokenAmount);
        //修改计数
        withdrawedTokens[beneficiary] = withdrawedTokens[beneficiary].add(tokenAmount);
        //变更币
        token.safeTransfer(beneficiary, tokenAmount);
        //发送事件
        TokenWithdrawed(beneficiary, tokenAmount);

    }

    function delegateWithdraw(address beneficiary) onlyOwner public {
        withdrawInternal(beneficiary, getWithdrawableAmount(beneficiary));
    }

    function batchDelegateWithdraw(address[] beneficiaries) onlyOwner public {
        for (uint256 i = 0; i < beneficiaries.length; i++) {
            delegateWithdraw(beneficiaries[i]);
        }
    }

}
