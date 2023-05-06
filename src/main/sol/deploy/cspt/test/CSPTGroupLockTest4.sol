pragma solidity ^0.4.18;

import '../../../lock/TokenGroupLock.sol';

contract CSPTGroupLockTest4 is TokenGroupLock{
    function CSPTGroupLockTest4() public TokenGroupLock(
        "Advisor", //name
        0xbd523e7580d27eC32306fa503803ed538FdD2Ae5, //walletAddress
        0xcb3e31497823b5a1cc79940b83a84c30096dfe11, //tokenAddress
        4, //_unlockTimes
        60 * 60 * 24 * 90 //_unlockCoolDown 90 days
    ) {
        transferOwnership(0x26295ad70B2f38DEb411Eb70Bf2254859D802567);
    }
}