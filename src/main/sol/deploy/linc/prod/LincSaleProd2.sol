pragma solidity ^0.4.18;

import '../../../sales/KycSale.sol';

/**
 * sale test
 */
contract LincSaleProd2 is KycSale {

    function LincSaleProd2() public KycSale(
        "公募",
        0x86990f5517cb24989F8eD9d9a29C6c2FDB4411C8, //walletAddress
        0x4dda7044dB5fA409Cc36629077ef6E56eE9a96Ee, //tokenAddress
        0, //kycAddress null for nouse
        (10 ** 18) * 50000000, //_tokenTotal
        16667//_rate
    ) {
         transferOwnership(0x48Fb8759AB0a6623A595b5d2d425334c0edE64B1);
   }
}
