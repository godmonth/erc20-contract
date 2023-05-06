pragma solidity ^0.4.18;

import './Ownable.sol';

contract HasName is Ownable {
    string public name;

    function setName(string _name) public onlyOwner {
        name = _name;
    }

}
