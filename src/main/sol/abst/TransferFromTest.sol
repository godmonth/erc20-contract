pragma solidity ^0.4.18;


import '../token/SafeERC20.sol';
import './AbstToken.sol';

contract TransferFromTest {
    using SafeERC20 for AbstToken;

    AbstToken public tokenContract;

    function TransferFromTest(address tokenAddress) public {
        tokenContract = AbstToken(tokenAddress);
    }

    function test(uint256 value) public {
        tokenContract.safeTransferFrom(msg.sender, this, value);
    }
}