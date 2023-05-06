pragma solidity ^0.4.18;


import '../token/SafeSuperTransfer.sol';
import '../token/SuperTransferToken.sol';

contract SuperTransferTest  {
    using SafeSuperTransfer for SuperTransferToken;

    SuperTransferToken public tokenContract;

    function SuperTransferTest(address _tokenAddress) public {
        tokenContract = SuperTransferToken(_tokenAddress);
    }

    function test(address _to, uint256 value) public {
        tokenContract.safeSuperTransfer(_to, value);
    }
}