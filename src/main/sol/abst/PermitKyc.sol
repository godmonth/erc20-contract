pragma solidity ^0.4.18;

import './Kyc.sol';

contract PermitKyc is Kyc {

    function permit(address customer) public view returns (bool){
        return true;
    }
}