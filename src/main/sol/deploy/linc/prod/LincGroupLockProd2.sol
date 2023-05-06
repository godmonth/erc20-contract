pragma solidity ^0.4.18;

import '../../../lock/TokenGroupLock.sol';

contract LincGroupLockProd2 is TokenGroupLock {
    function LincGroupLockProd2() public TokenGroupLock(
        "私募一", //name
        0x86990f5517cb24989F8eD9d9a29C6c2FDB4411C8, //walletAddress
        0x4dda7044dB5fA409Cc36629077ef6E56eE9a96Ee, //tokenAddress
        2, //_unlockTimes
        60 * 60 * 24 * 90 //_unlockCoolDown 90 days
    ) {
        transferOwnership(0x48Fb8759AB0a6623A595b5d2d425334c0edE64B1);
    }
}
