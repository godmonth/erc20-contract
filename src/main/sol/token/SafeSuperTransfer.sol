pragma solidity ^0.4.18;

import './SuperTransferToken.sol';


library SafeSuperTransfer {
    function safeSuperTransfer(SuperTransferToken token, address to, uint256 value) internal {
        assert(token.superTransfer(to, value));
    }


}