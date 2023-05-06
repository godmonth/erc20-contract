pragma solidity ^0.4.18;

import '../../../lock/TokenGroupLock.sol';

contract LincGroupLockProd4 is TokenGroupLock {
    function LincGroupLockProd4() public TokenGroupLock(
        "Team", //name
        0x86990f5517cb24989F8eD9d9a29C6c2FDB4411C8, //walletAddress
        0x4dda7044dB5fA409Cc36629077ef6E56eE9a96Ee, //tokenAddress
        8, //_unlockTimes
        60 * 60 * 24 * 90 //_unlockCoolDown 90 days
    ) {
        transferOwnership(0x48Fb8759AB0a6623A595b5d2d425334c0edE64B1);
    }
}
