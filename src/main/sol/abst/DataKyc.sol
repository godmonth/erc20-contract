pragma solidity ^0.4.18;

import './Kyc.sol';
import '../ownership/Ownable.sol';

contract DataKyc is Kyc, Ownable {
    mapping(address => bool) customers;

    function permit(address customer) public view returns (bool){
        return customers[customer];
    }

    function addCustomer(address customer) public onlyOwner {
        customers[customer] = true;
    }

    function deleteCustomer(address customer) public onlyOwner {
        delete customers[customer];
    }
}