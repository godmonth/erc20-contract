pragma solidity ^0.4.18;

import '../../../sales/KycPhase2Sale.sol';

contract DCCPublicSaleTest is KycPhase2Sale {

    function DCCPublicSaleTest() public KycPhase2Sale(
        "DCCPublicSaleTest",
        msg.sender, //walletAddress
        0xe43FC068f23923d5DB2e854F3fb8bd2AD77E0559, //tokenAddress
        0x2c4419fd77c2f8961805c3a947d6310005766927, //kycAddress
        (10 ** 18) * 100002, //_tokenTotal
        0 //_rate
    ) {
    }
}
