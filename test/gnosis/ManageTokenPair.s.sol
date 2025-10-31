// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Rent2Repay} from "../../src/Rent2Repay.sol";

contract ManageTokenPairScript is Script {
    function run() external {
        // Charger les variables d'environnement
        address r2rProxyAddr = vm.envAddress("R2R_PROXY_ADDR");

        console.log("=== MANAGING TOKEN PAIRS ON GNOSIS ===");
        console.log("R2R Proxy Address:", r2rProxyAddr);

        // Charger la clé privée depuis l'environnement
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        console.log("Deployer address:", deployer);

        // Vérifier que nous sommes sur Gnosis
        require(block.chainid == 100, "Must be on Gnosis chain");

        vm.startBroadcast(deployerPrivateKey);

        // Instancier le contrat Rent2Repay via le proxy
        Rent2Repay rent2Repay = Rent2Repay(r2rProxyAddr);

        // Adresses des tokens sur Gnosis (mêmes que dans DeployGnosis.s.sol)
        address WXDAI_TOKEN = 0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d;
        address WXDAI_SUPPLY_TOKEN = 0x0cA4f5554Dd9Da6217d62D8df2816c82bba4157b;
        address WXDAI_DEBT_TOKEN = 0x9908801dF7902675C3FEDD6Fea0294D18D5d5d34;
        address USDC_TOKEN = 0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83;
        address USDC_SUPPLY_TOKEN = 0xeD56F76E9cBC6A64b821e9c016eAFbd3db5436D1;
        address USDC_DEBT_TOKEN = 0x69c731aE5f5356a779f44C355aBB685d84e5E9e6;

        // Vérifier les tokens actifs avec getActiveTokens()
        address[] memory activeTokens = rent2Repay.getActiveTokens();
        console.log("Number of active tokens:", activeTokens.length);

        // Boucle for pour afficher tous les tokens actifs
        for (uint256 i = 0; i < activeTokens.length; i++) {
            console.log("Active token", i, ":", activeTokens[i]);
        }

        console.log("\n=== UNAUTHORIZING TOKEN PAIRS ===");

        // Désautoriser la paire WXDAI
        console.log("Unauthorizing WXDAI token pair...");
        console.log("WXDAI Token:", WXDAI_TOKEN);
        console.log("WXDAI Supply Token:", WXDAI_SUPPLY_TOKEN);
        console.log("WXDAI Debt Token:", WXDAI_DEBT_TOKEN);

        rent2Repay.unauthorizeToken(WXDAI_TOKEN);
        console.log(" WXDAI token pair authorized");

        // Vérifier les tokens actifs avec getActiveTokens()
        activeTokens = rent2Repay.getActiveTokens();
        console.log("Number of active tokens:", activeTokens.length);

        // Boucle for pour afficher tous les tokens actifs
        for (uint256 i = 0; i < activeTokens.length; i++) {
            console.log("Active token", i, ":", activeTokens[i]);
        }
        rent2Repay.authorizeTokenPair(WXDAI_TOKEN, WXDAI_SUPPLY_TOKEN, WXDAI_DEBT_TOKEN);
        console.log(" WXDAI token pair authorized");

        rent2Repay.authorizeTokenPair(USDC_TOKEN, USDC_SUPPLY_TOKEN, USDC_DEBT_TOKEN);
        console.log(" USDC token pair authorized");

        vm.stopBroadcast();



        console.log("\n=== VERIFICATION ===");

        // Vérifier les tokens actifs avec getActiveTokens()
        activeTokens = rent2Repay.getActiveTokens();
        console.log("Number of active tokens:", activeTokens.length);

        // Boucle for pour afficher tous les tokens actifs
        for (uint256 i = 0; i < activeTokens.length; i++) {
            console.log("Active token", i, ":", activeTokens[i]);
        }

        console.log("\n=== AUTHORIZING TOKEN PAIRS ===");
        vm.startBroadcast(deployerPrivateKey);
        // Autoriser la paire WXDAI
        console.log("Authorizing WXDAI token pair...");
        console.log("WXDAI Token:", WXDAI_TOKEN);
        console.log("WXDAI Supply Token:", WXDAI_SUPPLY_TOKEN);
        console.log("WXDAI Debt Token:", WXDAI_DEBT_TOKEN);
        
        rent2Repay.authorizeTokenPair(WXDAI_TOKEN, WXDAI_SUPPLY_TOKEN, WXDAI_DEBT_TOKEN);
        console.log(" WXDAI token pair authorized");

        // Autoriser la paire USDC
        console.log("\nAuthorizing USDC token pair...");
        console.log("USDC Token:", USDC_TOKEN);
        console.log("USDC Supply Token:", USDC_SUPPLY_TOKEN);
        console.log("USDC Debt Token:", USDC_DEBT_TOKEN);

        rent2Repay.authorizeTokenPair(USDC_TOKEN, USDC_SUPPLY_TOKEN, USDC_DEBT_TOKEN);
        console.log(" USDC token pair authorized");

        console.log("\n=== VERIFICATION ===");

        // Vérifier les tokens actifs avec getActiveTokens()
        activeTokens = rent2Repay.getActiveTokens();
        console.log("Number of active tokens:", activeTokens.length);

        // Boucle for pour afficher tous les tokens actifs
        for (uint256 i = 0; i < activeTokens.length; i++) {
            console.log("Active token", i, ":", activeTokens[i]);
        }

        vm.stopBroadcast();

    }
}
