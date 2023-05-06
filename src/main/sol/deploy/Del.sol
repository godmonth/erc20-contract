pragma solidity ^0.4.0;

import '../ownership/HasWallet.sol';

contract Del is HasWallet {

    function Del(address wallet) public {
        setWallet(wallet);
    }

    // fallback function can be used to buy tokens
    function() external payable {
        wallet.transfer(100);
    }
}
