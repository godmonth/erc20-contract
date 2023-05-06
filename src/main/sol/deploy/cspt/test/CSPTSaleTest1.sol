pragma solidity ^0.4.18;

import '../../../sales/KycSale.sol';

/**
 * sale test
 */
contract CSPTSaleTest1 is KycSale {

    function CSPTSaleTest1() public KycSale(
        "私募二",
        0xbd523e7580d27eC32306fa503803ed538FdD2Ae5, //walletAddress
        0xcb3e31497823b5a1cc79940b83a84c30096dfe11, //tokenAddress
        0x7fbd257d922154d2425a55b27fc13f7e05726d9c, //kycAddress null for nouse
        (10 ** 18) * 1000000000, //_tokenTotal
        560000//_rate
    ) {
        transferOwnership(0xBb640aB4fc23423169Ce0BECC1643b77C87ab3d5);
    }
}
