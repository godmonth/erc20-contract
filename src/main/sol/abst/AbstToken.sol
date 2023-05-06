pragma solidity ^0.4.18;

import '../token/ParameterizedToken.sol';


contract AbstToken is ParameterizedToken {
    function AbstToken(string _name, string _symbol, uint256 _decimals) public
    ParameterizedToken(_name, _symbol, _decimals) {
    }

   

}