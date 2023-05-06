pragma solidity ^0.4.18;

import '../token/SafeERC20.sol';
import '../token/MintableToken.sol';
import './HasWallet.sol';

contract HasMintableToken is HasWallet {

    using SafeERC20 for MintableToken;

    MintableToken public token;

    function withdrawToken2Wallet(uint256 tokenAmount) public onlyOwner {
        require(tokenAmount > 0);
        token.safeTransfer(wallet, tokenAmount);
    }

    function setToken(address tokenAddress) public onlyOwner {
        require(tokenAddress != address(0));
        token = MintableToken(tokenAddress);
    }

    function getSelfHoldTokenAmount() view public returns (uint256){
        return token.balanceOf(this);
    }

    function hasMintAuthorization() view public returns (bool){
        return token.operators(this);
    }
}
