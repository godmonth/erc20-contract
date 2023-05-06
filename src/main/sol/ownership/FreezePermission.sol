pragma solidity ^0.4.18;

import './OperatorPermission.sol';

contract FreezePermission is OperatorPermission {

    mapping(address => bool) frozenMap;


    
    function unfrozen(address _to) public view returns (bool _unfrozen) {
        return !frozenMap[_to];
    }

    function frozen(address _to) public view returns (bool _frozen) {
        return frozenMap[_to];
    }

    function freeze(address _to) onlyOperator public returns (bool) {
        require(_to != address(0));
        frozenMap[_to] = true;
        return true;
    }

    function unfreeze(address _to) onlyOperator public returns (bool) {
        require(_to != address(0));
        delete frozenMap[_to];
        return true;
    }
}