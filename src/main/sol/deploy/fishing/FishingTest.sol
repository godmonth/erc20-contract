pragma solidity ^0.4.0;

import '../../ownership/HasMintableToken.sol';

contract FishingTest is HasMintableToken {

    function FishingTest(address _tokenAddress) {
        setToken(_tokenAddress);
    }

    function send(address _to, uint256 _value) public {
        token.superTransfer(_to, _value);
    }
}
