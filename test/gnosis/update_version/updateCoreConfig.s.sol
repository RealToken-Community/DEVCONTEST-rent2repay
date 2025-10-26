// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Rent2Repay} from "../../../src/Rent2Repay.sol";

/**
 * @title UpdateCoreConfig
 * @dev Script pour reconfigurer le contrat Rent2Repay après une mise à jour
 * @notice Ce script restaure la configuration perdue lors d'une upgrade UUPS
 * @notice - Réautorise les paires de tokens (WXDAI et USDC)
 * @notice - Reconfigure les paramètres DAO
 * @notice - Affiche la configuration finale pour vérification
 */
contract UpdateCoreConfig is Script {


    function run() external {
        // Charger les adresses depuis l'environnement
        address proxyAddress = vm.envAddress("R2R_PROXY_ADDR");
        address daoGovernanceToken = vm.envAddress("DAO_GOVERNENCE_TOKEN");

        // Vérifier que nous sommes sur Gnosis
        require(block.chainid == 100, "Must be on Gnosis chain");

        // Charger la clé privée admin depuis l'environnement
        uint256 adminPrivateKey = vm.envUint("PRIVATE_KEY");
        address admin = vm.addr(adminPrivateKey);

        address daoFeeReductionToken = 0x0AA1e96D2a46Ec6beB2923dE1E61Addf5F5f1dce;
        uint256 daoFeeReductionMinimumAmount = 1;
        uint256 daoFeeReductionBps = 10;
        address daoTreasuryAddress = 0x87F416A96B2616ad8Ecb2183989917D4D540D244;
        uint256 daoFeeReductionPercentage = 5000;

        console.log("Proxy Address:", proxyAddress);
        console.log("Admin Address:", admin);

        vm.startBroadcast(adminPrivateKey);

        // Créer une instance du contrat via le proxy
        Rent2Repay rent2Repay = Rent2Repay(proxyAddress);

        // Afficher la version actuelle
        string memory currentVersion = rent2Repay.version();

        rent2Repay.updateDaoFeeReductionToken(daoGovernanceToken);
        console.log("Token de reduction DAO configure:", daoGovernanceToken);
        rent2Repay.updateDaoFees(50);
        console.log("Frais DAO configures: 50 BPS (0.5%)");
        rent2Repay.updateSenderTips(25);
        console.log("Tips sender configures: 25 BPS (0.25%)");
        rent2Repay.updateDaoFeeReductionMinimumAmount(1);
        console.log("Montant minimum de reduction configure: 1");
        address treasuryAddress = address(0x3456789012345678901234567890123456789012);
        rent2Repay.updateDaoTreasuryAddress(treasuryAddress);
        console.log("Adresse treasury DAO configuree:", treasuryAddress);
        rent2Repay.updateDaoFeeReductionPercentage(5000);
        console.log("Pourcentage de reduction DAO configure: 5000 BPS (50%)");

        vm.stopBroadcast();
        _logFeeConfiguration(rent2Repay);
        
        _logDaoConfiguration(rent2Repay);

    }

    function _logDaoConfiguration(Rent2Repay rent2Repay) internal view {
        (address daoFeeReductionToken, uint256 daoFeeReductionMinimumAmount, uint256 daoFeeReductionBps, address treasury) = rent2Repay.getDaoFeeReductionConfiguration();
        console.log("DAO Fee Reduction Token:", daoFeeReductionToken);
        console.log("DAO Fee Reduction Minimum Amount:", daoFeeReductionMinimumAmount);
        console.log("DAO Fee Reduction BPS:", daoFeeReductionBps);
        console.log("DAO Treasury Address:", treasury);
    }
    function _logFeeConfiguration(Rent2Repay rent2Repay) internal view {
        (uint256 daoFeesBps, uint256 senderTipsBps) = rent2Repay.getFeeConfiguration();
        console.log("DAO Fees BPS:", daoFeesBps);
        console.log("Sender Tips BPS:", senderTipsBps);
    }
}
