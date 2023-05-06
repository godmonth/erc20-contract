pragma solidity ^0.4.18;

import '../../../lock/TokenGroupLock.sol';

contract LincGroupLockTest is TokenGroupLock {
    function LincGroupLockTest() public TokenGroupLock(
        "testLock", //name
        0x86990f5517cb24989F8eD9d9a29C6c2FDB4411C8, //walletAddress
        0xe43FC068f23923d5DB2e854F3fb8bd2AD77E0559, //tokenAddress
        13, //_unlockTimes
        60 * 1 //_unlockCoolDown
    ) {

    }
}
