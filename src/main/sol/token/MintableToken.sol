pragma solidity ^0.4.18;

import './FreezableToken.sol';
import './StandardToken.sol';
/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
 */

contract MintableToken is FreezableToken {
    event Mint(address indexed to, uint256 amount);

    event Burn(address indexed from, uint256 amount);

    event MintFinished();

    bool public mintingFinished = false;

    modifier canMint() {
        require(!mintingFinished);
        _;
    }
    mapping(address => bool) public minters;

    modifier onlyMinters() {
        require(minters[msg.sender] || msg.sender == owner);
        _;
    }
    function addMinter(address _addr) public onlyOwner {
        require(_addr != address(0));
        minters[_addr] = true;
    }

    function deleteMinter(address _addr) public onlyOwner {
        require(_addr != address(0));
        delete minters[_addr];
    }


    /**
     * @dev Function to mint tokens
     * @param _to The address that will receive the minted tokens.
     * @param _amount The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
        require(_to != address(0));
        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        Mint(_to, _amount);
        Transfer(address(0), _to, _amount);
        return true;
    }

    /**
       * @dev Function to mint tokens
       * @param _amount The amount of tokens to mint.
       * @return A boolean that indicates if the operation was successful.
       */
    function burn(uint256 _amount) public onlyMinters returns (bool) {
        address _to = msg.sender;
        require(_amount > 0);
        require(_amount <= balances[_to] && _amount <= totalSupply);
        balances[_to] = balances[_to].sub(_amount);
        totalSupply = totalSupply.sub(_amount);

        Burn(_to, _amount);
        return true;
    }

    /**
     * @dev Function to stop minting new tokens.
     * @return True if the operation was successful.
     */
    function finishMinting() onlyOwner canMint public returns (bool) {
        mintingFinished = true;
        MintFinished();
        return true;
    }
}