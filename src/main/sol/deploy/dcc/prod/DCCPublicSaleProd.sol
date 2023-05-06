pragma solidity ^0.4.18;

import '../../../sales/KycPhase2Sale.sol';

contract DCCPublicSaleProd is KycPhase2Sale {

    function DCCPublicSaleProd() public KycPhase2Sale(
        "DCCPublicSale",
        msg.sender, //walletAddress
        0xFFa93Aacf49297D51E211817452839052FDFB961, //tokenAddress
        0, //kycAddress
        10, //_tokenTotal
        2 //_rate
    ) {
    }
}
