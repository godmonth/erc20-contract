pragma solidity ^0.4.18;

import './RoundParamater.sol';

import '../math/SafeMath.sol';
import '../ownership/HasName.sol';
import '../ownership/HasToken.sol';

contract TokenGroupLock2 is RoundParamater, HasName, HasToken {

    using SafeMath for uint256;

    using SafeERC20 for ERC20;

    uint256 public totalPreservedAmount;

    uint256 public totalWithdrawedAmount;

    string public version = "1.0";

    function getPreservedAmount(address memberAddress) public view returns (uint256 preservedAmount);

    function setPreservedAmount(address memberAddress, uint256 preservedAmount) internal;

    function getWithdrawedAmount(address memberAddress) public view returns (uint256 withdrawedAmount);

    function setWithdrawedAmount(address memberAddress, uint256 withdrawedAmount) internal;

    function addMember(address memberAddress, uint256 preservedAmount) onlyOwner public {
        require(memberAddress != address(0));
        require(preservedAmount > 0);
        //没有重复
        require(preservedAmounts[memberAddress] == 0);

        preservedAmounts[memberAddress] = preservedAmount;
        totalPreservedAmount = totalPreservedAmount.add(preservedAmount);
    }

    function getSpareAmount() view public returns (uint256){
        uint256 actualHold = token.balanceOf(this);
        return actualHold.sub(totalPreservedAmount.sub(totalWithdrawedAmount));
    }

    function getUnlockedAmount(address memberAddress) view public returns (uint256){
        require(memberAddress != address(0));
        uint256 round = getRound();
        if (round == 0) {
            return 0;
        }
        return preservedAmounts[memberAddress].mul(round).div(unlockTimes);
    }

    function getWithdrawableAmount(address memberAddress) view public returns (uint256){
        return getUnlockedAmount(memberAddress).sub(withdrawedAmounts[memberAddress]);
    }

    function withdraw(address memberAddress) public {
        uint256 tokenAmount = getWithdrawableAmount(memberAddress);
        require(tokenAmount > 0);

        withdrawedAmounts[memberAddress] = withdrawedAmounts[memberAddress].add(tokenAmount);
        totalWithdrawedAmount = totalWithdrawedAmount.add(tokenAmount);

        //变更币
        token.safeTransfer(memberAddress, tokenAmount);

    }

    function batchWithdraw(address[] _memberAddressArray) public {
        for (uint256 i = 0; i < _memberAddressArray.length; i++) {
            withdraw(_memberAddressArray[i]);
        }
    }

}
