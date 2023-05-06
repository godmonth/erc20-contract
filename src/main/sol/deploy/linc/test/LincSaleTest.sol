pragma solidity ^0.4.18;

import '../../../sales/KycSale.sol';

/**
 * sale test
 */
contract LincSaleTest is KycSale {

    function LincSaleTest() public KycSale(
        "testSale1",
        msg.sender, //walletAddress
        0xe43FC068f23923d5DB2e854F3fb8bd2AD77E0559, //tokenAddress
        0, //kycAddress null for nouse
        (10 ** 18) * 1, //_total
        7//_rate
    ) {
    }
}
