pragma solidity ^0.4.11;

import '../ownership/HasToken.sol';

contract Aw is HasToken {
    event Transfer(address indexed from, address indexed to, uint256 value);

    function Aw(address token) public {
        setToken(token);
    }

    function eee(address to) public {
        Transfer(msg.sender, to, 2);
        token.transfer(to, 1);
    }
}
