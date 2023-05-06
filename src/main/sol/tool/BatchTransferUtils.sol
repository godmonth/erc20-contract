pragma solidity ^0.4.18;

import '../ownership/OperatorPermission.sol';
import '../token/SafeERC20.sol';
import '../token/ERC20.sol';

contract BatchTransferUtils is OperatorPermission {
    using SafeERC20 for ERC20;

    function batchTransfer(address tokenAddress, address[] beneficiaries, uint256[] tokenAmount) onlyOperator public returns (bool) {
        require(tokenAddress != address(0));
        require(beneficiaries.length > 0 && beneficiaries.length == tokenAmount.length);
        ERC20 ERC20Contract = ERC20(tokenAddress);
        for (uint256 i = 0; i < beneficiaries.length; i++) {
            require(beneficiaries[i] != address(0));
            require(tokenAmount[i] > 0);
            ERC20Contract.safeTransferFrom(msg.sender, beneficiaries[i], tokenAmount[i]);
        }
        return true;
    }
}
