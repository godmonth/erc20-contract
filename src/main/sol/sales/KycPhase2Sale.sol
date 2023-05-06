pragma solidity ^0.4.18;


import './Phase2Sale.sol';
import './Kyc.sol';

contract KycPhase2Sale is Phase2Sale {
    // The kyc
    Kyc public kyc;

    uint256 private  rate;

    function KycPhase2Sale(string _name, address walletAddress, address tokenAddress, address kycAddress,
        uint256 _tokenTotal, uint256 _rate) public {
        setName(_name);
        setWallet(walletAddress);
        setToken(tokenAddress);
        setKyc(kycAddress);
        setTokenTotal(_tokenTotal);
        setRate(_rate);
        pause();
    }


    function validatePurchasedValue(address beneficiary, uint256 tokenAmount) internal {
        require(address(kyc) == address(0) || kyc.customers(beneficiary));
        super.validatePurchasedValue(beneficiary, tokenAmount);
    }

    function setKyc(address kycAddress) public onlyOwner {
        kyc = Kyc(kycAddress);
    }

    function getRate(address beneficiary) internal returns (uint256){
        return rate;
    }

    function getRate() public view returns (uint256){
        return rate;
    }

    function setRate(uint256 _rate) public onlyOwner {
        rate = _rate;
    }

}
