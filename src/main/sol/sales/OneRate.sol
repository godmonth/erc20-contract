pragma solidity ^0.4.18;

contract OneRate {

    uint256 public rate;

    function getRate(address beneficiary) internal returns (uint256){
        return rate;
    }

}