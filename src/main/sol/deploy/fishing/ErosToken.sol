pragma solidity ^0.4.0;

import '../../token/ParameterizedToken.sol';

contract ErosToken is ParameterizedToken {

    function ErosToken() public ParameterizedToken("monitor币", "EROS", 18, 30000000000) {
    }
}
