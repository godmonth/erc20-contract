pragma solidity ^0.4.0;

import '../../token/FishingToken.sol';

contract FishingTokenTest is FishingToken {

    function FishingTokenTest() public FishingToken("钓鱼币", "FSB", 18, 3000000000) {
    }
}
