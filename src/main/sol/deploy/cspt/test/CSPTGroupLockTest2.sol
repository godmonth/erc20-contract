pragma solidity ^0.4.18;

import '../../../lock/TokenGroupLock.sol';

contract CSPTGroupLockTest2 is TokenGroupLock {
    function CSPTGroupLockTest2() public TokenGroupLock(
        "私募一", //name
        0xbd523e7580d27eC32306fa503803ed538FdD2Ae5, //walletAddress
        0xcb3e31497823b5a1cc79940b83a84c30096dfe11, //tokenAddress
        1, //_unlockTimes
        60 * 60 * 24 * 90 //_unlockCoolDown 90 days
    ) {
        transferOwnership(0xBb640aB4fc23423169Ce0BECC1643b77C87ab3d5);
    }
}