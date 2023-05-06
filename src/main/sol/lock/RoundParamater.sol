pragma solidity ^0.4.18;

import '../math/Math.sol';
import '../math/SafeMath.sol';
import '../ownership/Ownable.sol';

contract RoundParamater is Ownable{
    using Math for uint256;

    using SafeMath for uint256;

    uint256 public unlockTimes;

    uint256 public unlockCoolDown;

    uint256 public unlockStartTimestamp;

    function getRound() view public returns (uint256){
        if (unlockStartTimestamp == 0 || block.timestamp < unlockStartTimestamp) {
            return 0;
        }
        return block.timestamp.sub(unlockStartTimestamp).div(unlockCoolDown).add(1).min256(unlockTimes);
    }

    function setUnlockStartTimestamp(uint256 _unlockStartTimestamp) onlyOwner public {
        unlockStartTimestamp = _unlockStartTimestamp;
    }

}
