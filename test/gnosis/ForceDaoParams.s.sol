// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Rent2Repay} from "../../src/Rent2Repay.sol";

contract ForceDaoParamsScript is Script {
    function run() external {
        // Charger les adresses depuis l'environnement
        address proxyAddress = vm.envAddress("R2R_PROXY_ADDR");
        address daoGovernanceToken = vm.envAddress("DAO_GOVERNENCE_TOKEN");

        require(block.chainid == 100, "Gnosis chain");

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // Créer une instance du contrat via le proxy
        Rent2Repay rent2Repay = Rent2Repay(proxyAddress);

        rent2Repay.updateDaoFeeReductionToken(daoGovernanceToken);
        rent2Repay.updateDaoFees(50);
        rent2Repay.updateSenderTips(25);
        rent2Repay.updateDaoFeeReductionMinimumAmount(1);
        rent2Repay.updateDaoTreasuryAddress(address(0x3456789012345678901234567890123456789012));
        rent2Repay.updateDaoFeeReductionPercentage(5000);

        // Check results
        (uint256 daoFeesBps, uint256 senderTipsBps) = rent2Repay.getFeeConfiguration();
        console.log("Sender Tips BPS after update:", senderTipsBps);
        console.log("DAO Fees BPS after update:", daoFeesBps);

        (
            address daoFeeReductionToken,
            uint256 daoFeeReductionMinimumAmount,
            uint256 daoFeeReductionBps,
            address treasury
        ) = rent2Repay.getDaoFeeReductionConfiguration();
        console.log("DAO Fee Reduction Token:", daoFeeReductionToken);
        console.log("DAO Fee Reduction Minimum Amount:", daoFeeReductionMinimumAmount);
        console.log("DAO Fee Reduction BPS:", daoFeeReductionBps);
        console.log("DAO Treasury Address:", treasury);

        vm.stopBroadcast();
    }
}
