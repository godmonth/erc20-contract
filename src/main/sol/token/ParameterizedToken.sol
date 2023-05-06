pragma solidity ^0.4.18;

import './MintableToken.sol';

contract ParameterizedToken is MintableToken {
    //1.4 add burn,add disableTransfer, add internal transfer,add SuperTransferToken(optional),add freezeable
    //(optional),SafeMint(optional),SafeSuperTransfer(optional),remove CappedToken inheritance
    //1.3 update add minter/delete minter address validation
    string public version = "1.4";

    string public name;

    string public symbol;

    uint256 public decimals;

    function ParameterizedToken(string _name, string _symbol, uint256 _decimals) public MintableToken() {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

}