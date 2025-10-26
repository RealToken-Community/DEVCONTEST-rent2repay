pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Rent2Repay} from "../../src/Rent2Repay.sol";

contract checkFeesScript is Script {
    function run() external {
        // Charger les adresses depuis l'environnement
        address proxyAddress = vm.envAddress("R2R_PROXY_ADDR");
        // Vérifier que nous sommes sur Gnosis
        require(block.chainid == 100, "Gnosis chain");

        // Créer une instance du contrat via le proxy
        Rent2Repay rent2Repay = Rent2Repay(proxyAddress);


        // Vérifier les tokens actifs avec getActiveTokens()
        address[] memory activeTokens = rent2Repay.getActiveTokens();
        console.log("Number of active tokens:", activeTokens.length);

        // Boucle for pour afficher tous les tokens actifs
        for (uint256 i = 0; i < activeTokens.length; i++) {
            console.log("Active token", i, ":",activeTokens[i]);
        }
    }
}