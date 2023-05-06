pragma solidity ^0.4.18;

import '../token/ParameterizedToken.sol';

contract MockToken is ParameterizedToken {

    function MockToken() public ParameterizedToken("testName", "testSymbol", 18, 3000000000) {
    }

}