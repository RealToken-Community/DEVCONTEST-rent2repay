// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Rent2Repay} from "../../src/Rent2Repay.sol";

contract UpdateDaoTokenScript is Script {
    function run() external {
        // Charger les adresses depuis l'environnement
        address proxyAddress = vm.envAddress("R2R_PROXY_ADDR");
        address daoGovernanceToken = vm.envAddress("DAO_GOVERNENCE_TOKEN");
        address usdcToken = vm.envAddress("USDC_TOKEN");

        require(block.chainid == 100, "Gnosis chain");

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // Créer une instance du contrat via le proxy
        Rent2Repay rent2Repay = Rent2Repay(proxyAddress);

        // TEST - Configuration des frais DAO
        (uint256 daoFeeBps, uint256 senderTipsBps) = rent2Repay.getFeeConfiguration();
        console.log("DAO Fee BPS:", daoFeeBps);
        console.log("Sender Tips BPS:", senderTipsBps);

        rent2Repay.updateDaoFees(1);
        (daoFeeBps, senderTipsBps) = rent2Repay.getFeeConfiguration();
        console.log("DAO Fee BPS after update:", daoFeeBps);

        rent2Repay.updateSenderTips(2);
        (daoFeeBps, senderTipsBps) = rent2Repay.getFeeConfiguration();
        console.log("Sender Tips BPS after update:", senderTipsBps);

        // TEST - Configuration de réduction des frais DAO
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

        rent2Repay.updateDaoFeeReductionToken(usdcToken);
        (daoFeeReductionToken,,,) = rent2Repay.getDaoFeeReductionConfiguration();
        console.log("DAO Fee Reduction Token after update:", daoFeeReductionToken);

        rent2Repay.updateDaoFeeReductionMinimumAmount(3);
        (, daoFeeReductionMinimumAmount,,) = rent2Repay.getDaoFeeReductionConfiguration();
        console.log("DAO Fee Reduction Minimum Amount after update:", daoFeeReductionMinimumAmount);

        rent2Repay.updateDaoFeeReductionPercentage(10000);
        (,, daoFeeReductionBps,) = rent2Repay.getDaoFeeReductionConfiguration();
        console.log("DAO Fee Reduction Percentage after update:", daoFeeReductionBps);

        rent2Repay.updateDaoTreasuryAddress(address(0x123));
        (,,, treasury) = rent2Repay.getDaoFeeReductionConfiguration();
        console.log("DAO Treasury Address after update:", treasury);

        // rollback
        rent2Repay.updateDaoFeeReductionToken(daoGovernanceToken);
        rent2Repay.updateDaoFees(50);
        rent2Repay.updateSenderTips(25);
        rent2Repay.updateDaoFeeReductionMinimumAmount(1);
        rent2Repay.updateDaoTreasuryAddress(address(0x3456789012345678901234567890123456789012));
        rent2Repay.updateDaoFeeReductionPercentage(5000);

        vm.stopBroadcast();
    }
}
