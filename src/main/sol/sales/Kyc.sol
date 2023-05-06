pragma solidity ^0.4.18;

import '../ownership/Ownable.sol';

contract Kyc is Ownable {

    mapping(address => bool) public customers;

    event AddedToCustomers(address indexed customer);

    event DeletedFromCustomers(address indexed customer);

    function addCustomer(address customer) public onlyOwner {
        customers[customer] = true;
        AddedToCustomers(customer);
    }

    function addCustomers(address[] _customers) public onlyOwner {
        for (uint256 i = 0; i < _customers.length; i++) {
            addCustomer(_customers[i]);
        }
    }

    function deleteCustomer(address customer) public onlyOwner {
        delete customers[customer];
        DeletedFromCustomers(customer);
    }

    function deleteCustomers(address[] _customers) public onlyOwner {
        for (uint256 i = 0; i < _customers.length; i++) {
            deleteCustomer(_customers[i]);
        }
    }
}