pragma solidity ^0.4.18;

import './CertIntf.sol';

contract IdAndBankcardKyc {
    CertIntf idCertService;

    CertIntf bankcardCertService;

    function IdAndBankcardKyc(address idCertServiceAddress, address bankcardCertServiceAddress){
        idCertService = CertIntf(idCertServiceAddress);
        bankcardCertService = CertIntf(bankcardCertServiceAddress);
    }


    function permit(address customer) public view returns (bool){
        var (digest1,,,) = idCertService.getData();
        var (digest2,,,) = bankcardCertService.getData();

        return digest1.length > 0 && digest2.length > 0;

    }
}