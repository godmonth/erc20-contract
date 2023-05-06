pragma solidity ^0.4.18;

import './RoundParamater.sol';
import '../math/SafeMath.sol';

contract TokenSingleLock is RoundParamater {
    using SafeMath for uint256;

    using SafeERC20 for ERC20;

    uint256 public preservedAmount;

    uint256 public withdrawedAmount;

    address public unlockAddress;

    uint256 public version = "1.0";

    function TokenSingleLock(string _name, address walletAddress, address tokenAddress, uint256
        _unlockTimes, uint256 _unlockCoolDown, address _unlockAddress, uint256 _preservedAmount) public {
        setName(_name);
        setWallet(walletAddress);
        setToken(tokenAddress);

        require(_unlockTimes > 0);
        unlockTimes = _unlockTimes;

        require(_unlockCoolDown > 0);
        unlockCoolDown = _unlockCoolDown;

        require(_unlockAddress != address(0));
        unlockAddress = _unlockAddress;

        require(_preservedAmount > 0);
        preservedAmount = _preservedAmount;
    }

    function getUnlockedAmount() view public returns (uint256){
        uint256 round = getRound();
        if (round == 0) {
            return 0;
        }
        return preservedAmount.mul(round).div(unlockTimes);
    }

    function getWithdrawableAmount() view public returns (uint256){
        return getUnlockAmount().sub(withdrawedAmount);
    }

    function withdraw() public {
        uint256 tokenAmount = getWithdrawableAmount();
        require(tokenAmount > 0);

        //变更币
        token.safeTransfer(wallet, tokenAmount);

        withdrawedAmount = withdrawedAmount.add(tokenAmount);
    }

}
