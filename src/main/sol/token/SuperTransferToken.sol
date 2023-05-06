pragma solidity ^0.4.18;

import './BasicToken.sol';

contract SuperTransferToken is BasicToken {
    /**
     * 操作人
     */
    mapping(address => bool) public superTransferPermissions;

    event SuperTransferPermissionAdded(address indexed permissionAddress);

    event SuperTransferPermissionDeleted(address indexed permissionAddress);

    modifier onlySuperTransfer(){
        require(inSuperTransferPermission(msg.sender));
        _;
    }
    function addSuperTransferPermission(address superTransfer) public onlyOwner {
        superTransferPermissions[superTransfer] = true;
        SuperTransferPermissionAdded(superTransfer);
    }

    function deleteSuperTransferPermission(address superTransfer) public onlyOwner {
        delete superTransferPermissions[superTransfer];
        SuperTransferPermissionDeleted(superTransfer);
    }

    function inSuperTransferPermission(address add) view public returns (bool){
        require(add != address(0));
        return superTransferPermissions[add] || (add == owner);
    }
    
    function superTransfer(address _to, uint256 _value) onlySuperTransfer public returns (bool) {
        return innerTransfer(tx.origin, _to, _value);
    }
 

}