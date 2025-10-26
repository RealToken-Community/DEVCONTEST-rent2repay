pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Rent2Repay} from "../../src/Rent2Repay.sol";

contract checkBalancesScript is Script {
    function run() external {
        // Charger les adresses depuis l'environnement
        address proxyAddress = vm.envAddress("R2R_PROXY_ADDR");
        address rmmAddress = vm.envAddress("RMM_ADDRESS");
        // Vérifier que nous sommes sur Gnosis
        require(block.chainid == 100, "Gnosis chain");

        // Charger la clé privée depuis l'environnement
        uint256 user1Key = vm.envUint("USER1_KEY");
        address user1 = vm.addr(user1Key);

        address usdcSupplyAddr = vm.envAddress("USDC_SUPPLY_TOKEN");
        address usdcAddr = vm.envAddress("USDC_TOKEN");
        address usdcDebtAddr = vm.envAddress("USDC_DEBT_TOKEN");

        vm.startBroadcast(user1Key);

        console.log("USER1 Checking balances R2R");
        uint256 balance = IERC20(usdcAddr).balanceOf(user1);
        console.log("Allowance USDC:", balance);
        balance = IERC20(usdcSupplyAddr).balanceOf(user1);
        console.log("Allowance USDC Supply:", balance);
        balance = IERC20(usdcDebtAddr).balanceOf(user1);
        console.log("Allowance USDC Debt:", balance);

        console.log("USER1 Checking allowances R2R");
        uint256 allowance = IERC20(usdcAddr).allowance(user1, proxyAddress);
        console.log("Allowance USDC:", allowance);
        allowance = IERC20(usdcSupplyAddr).allowance(user1, proxyAddress);
        console.log("Allowance USDC Supply:", allowance);

        console.log("USR 1 Checking allowances RMM");
        allowance = IERC20(usdcAddr).allowance(user1, rmmAddress);
        console.log("Allowance USDC:", allowance);
        if (allowance == 0) {
            IERC20(usdcAddr).approve(rmmAddress, type(uint256).max);
            allowance = IERC20(usdcAddr).allowance(user1, rmmAddress);
            console.log("New Allowance USDC:", allowance);
        }
        allowance = IERC20(usdcSupplyAddr).allowance(user1, rmmAddress);
        console.log("Allowance USDC Supply:", allowance);
        if (allowance == 0) {
            IERC20(usdcAddr).approve(rmmAddress, type(uint256).max);
            allowance = IERC20(usdcAddr).allowance(user1, rmmAddress);
            console.log("Allowance USDC:", allowance);
        }
        console.log("R2R Checking allowances RMM");
        allowance = IERC20(usdcAddr).allowance(proxyAddress, rmmAddress);
        console.log("Allowance USDC:", allowance);

        allowance = IERC20(usdcSupplyAddr).allowance(proxyAddress, rmmAddress);
        console.log("Allowance USDC Supply:", allowance);

        // we check user config on R2R
        Rent2Repay rent2Repay = Rent2Repay(proxyAddress);
        user1 = 0x19f35F822e34Bd9497CDf376350643FA2f6c3B81;
        (address[] memory tokens, uint256[] memory maxAmounts) = rent2Repay.getUserConfigs(user1);
        console.log("User1 address:", user1);
        for (uint256 i = 0; i < tokens.length; i++) {
            console.log("Token:", tokens[i]);
            console.log("Max Amount:", maxAmounts[i]);
        }
    }
}
