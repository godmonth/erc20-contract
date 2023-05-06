pragma solidity ^0.4.18;

import './StandardToken.sol';

contract FreezableToken is StandardToken {
    mapping(address => bool) frozenMap;

    function unfrozen(address _to) public view returns (bool _unfrozen) {
        return !frozenMap[_to];
    }

    function frozen(address _to) public view returns (bool _frozen) {
        return frozenMap[_to];
    }

    function freeze(address _to) onlyOwner public returns (bool) {
        require(_to != address(0));
        frozenMap[_to] = true;
        return true;
    }

    function unfreeze(address _to) onlyOwner public returns (bool) {
        require(_to != address(0));
        delete frozenMap[_to];
        return true;
    }

     function innerTransfer(address _from, address _to, uint256 _value) internal returns (bool) {
        require(unfrozen(_from));
        require(unfrozen(_to));
        return super.innerTransfer(_from, _to, _value);
    }

//    function superTransfer(address _to, uint256 _value) onlySuperTransfer public returns (bool) {
//        return innerTransfer(tx.origin, _to, _value);
//    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(unfrozen(msg.sender));
        require(unfrozen(_from));
        require(unfrozen(_to));
        return super.transferFrom(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        require(unfrozen(msg.sender));
        require(unfrozen(_spender));
        return super.approve(_spender, _value);
    }

    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
        require(unfrozen(msg.sender));
        require(unfrozen(_spender));
        return super.increaseApproval(_spender, _addedValue);
    }

    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
        require(unfrozen(msg.sender));
        require(unfrozen(_spender));
        return super.decreaseApproval(_spender, _subtractedValue);
    }
}