pragma solidity ^0.4.18;

import '../../../lock/TokenGroupLock.sol';

contract CSPTGroupLockProd1 is TokenGroupLock{
    function CSPTGroupLockProd1() public TokenGroupLock(
        "天使轮", //name
        0xbd523e7580d27eC32306fa503803ed538FdD2Ae5, //walletAddress
        0xcb3e31497823b5a1cc79940b83a84c30096dfe11, //tokenAddress
        2, //_unlockTimes
        60 * 60 * 24 * 90 //_unlockCoolDown 90 days
    ) {
        transferOwnership(0xBb640aB4fc23423169Ce0BECC1643b77C87ab3d5);
    }
}