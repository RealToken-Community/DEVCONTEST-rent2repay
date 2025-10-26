pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Rent2Repay} from "../../src/Rent2Repay.sol";

contract checkUserConfigScript is Script {
    function run() external {
        // Charger les adresses depuis l'environnement
        address proxyAddress = vm.envAddress("R2R_PROXY_ADDR");
        //address rmmAddress = vm.envAddress("RMM_ADDRESS");
        // Vérifier que nous sommes sur Gnosis
        require(block.chainid == 100, "Gnosis chain");

        Rent2Repay rent2Repay = Rent2Repay(proxyAddress);
        address user1 = 0xcf92E7704A5B778e7474B0e27E67F2b2452cF26c;
        (address[] memory tokens, uint256[] memory maxAmounts) = rent2Repay.getUserConfigs(user1);
        console.log("User1 address:", user1);
        for (uint256 i = 0; i < tokens.length; i++) {
            console.log("Token:", tokens[i]);
            console.log("Max Amount:", maxAmounts[i]);
        }

        // Vérifier les montants spécifiques pour des tokens particuliers
        address[] memory specificTokens = new address[](4);
        specificTokens[0] = 0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83; // USDC
        specificTokens[1] = 0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d; // WXDAI
        specificTokens[2] = 0xeD56F76E9cBC6A64b821e9c016eAFbd3db5436D1; // ARMMUSDC
        specificTokens[3] = 0x0cA4f5554Dd9Da6217d62D8df2816c82bba4157b; // ARMMWXDAI

        string[] memory tokenNames = new string[](4);
        tokenNames[0] = "USDC";
        tokenNames[1] = "WXDAI";
        tokenNames[2] = "ARMMUSDC";
        tokenNames[3] = "ARMMWXDAI";

        for (uint256 i = 0; i < specificTokens.length; i++) {
            uint256 tmpAmounts = rent2Repay.allowedMaxAmounts(user1, specificTokens[i]);
            console.log(tokenNames[i], ":", tmpAmounts);
        }
    }
}
