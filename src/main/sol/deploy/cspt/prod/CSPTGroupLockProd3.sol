pragma solidity ^0.4.18;

import '../../../lock/TokenGroupLock.sol';

contract CSPTGroupLockProd3 is TokenGroupLock {
    function CSPTGroupLockProd3() public TokenGroupLock(
        "Team", //name
        0xbd523e7580d27eC32306fa503803ed538FdD2Ae5, //walletAddress
        0xcb3e31497823b5a1cc79940b83a84c30096dfe11, //tokenAddress
        8, //_unlockTimes
        60 * 60 * 24 * 90 //_unlockCoolDown 90 days
    ) {
        transferOwnership(0xbEA2Bf64C5A24a82b1234AbBB87bd59bf1426718);
    }
}