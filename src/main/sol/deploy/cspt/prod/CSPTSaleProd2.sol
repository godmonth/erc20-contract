pragma solidity ^0.4.18;

import '../../../sales/KycSale.sol';

/**
 * sale test
 */
contract CSPTSaleProd2 is KycSale {

    function CSPTSaleProd2() public KycSale(
        "公募",
        0xbd523e7580d27eC32306fa503803ed538FdD2Ae5, //walletAddress
        0xcb3e31497823b5a1cc79940b83a84c30096dfe11, //tokenAddress
        0, //kycAddress null for nouse
        (10 ** 18) * 500000000, //_tokenTotal
        500000//_rate
    ) {
         transferOwnership(0xBb640aB4fc23423169Ce0BECC1643b77C87ab3d5);
   }
}
