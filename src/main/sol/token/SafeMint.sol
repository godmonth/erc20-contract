pragma solidity ^0.4.18;

import './MintableToken.sol';


library SafeMint {
    function safeMint(MintableToken token, address to, uint256 value) internal {
        assert(token.mint(to, value));
    }

    function safeBurn(MintableToken token, uint256 value) internal {
        assert(token.burn(value));
    }
}