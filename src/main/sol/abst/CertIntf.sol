pragma solidity ^0.4.18;

contract CertIntf {
    function getData() view public returns (bytes digest1, bytes digest2, uint256 expired, uint256 dataVersion);

}