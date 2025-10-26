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

        // Charger la clé privée depuis l'environnement
        uint256 user1Key = vm.envUint("USER1_KEY");
        address user1 = vm.addr(user1Key);

        uint256 admin_k = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(admin_k);

        // Créer une instance du contrat via le proxy
        Rent2Repay rent2Repay = Rent2Repay(proxyAddress);

        // Récupérer la configuration des frais via getFeeConfiguration()
        (uint256 daoFeesBps, uint256 senderTipsBps) = rent2Repay.getFeeConfiguration();
        console.log("Sender Tip BPS:", senderTipsBps);
        console.log("DAO Fees BPS:", daoFeesBps);

        // Récupérer la configuration de réduction des frais DAO via getDaoFeeReductionConfiguration()
        (
            address daoFeeReductionToken,
            uint256 daoFeeReductionMinimumAmount,
            uint256 daoFeeReductionBps,
            address daoTreasuryAddress
        ) = rent2Repay.getDaoFeeReductionConfiguration();

        console.log("DAO Fee Reduction Token:", daoFeeReductionToken);
        console.log("DAO Fee Reduction Minimum Amount:", daoFeeReductionMinimumAmount);
        console.log("DAO Fee Reduction BPS:", daoFeeReductionBps);
        console.log("DAO Treasury Address:", daoTreasuryAddress);

        //rent2Repay.updateDaoFeeReductionMinimumAmount(2);
        rent2Repay.updateDaoFeeReductionMinimumAmount(type(uint256).max);

        // Récupérer la nouvelle valeur après mise à jour
        (, uint256 newDaoFeeReductionMinimumAmount,,) = rent2Repay.getDaoFeeReductionConfiguration();
        console.log("DAO Fee Reduction Minimum Amount:", newDaoFeeReductionMinimumAmount);

        uint256 amount = IERC20(daoFeeReductionToken).balanceOf(user1);
        console.log("User1 DAO Fee Reduction Token Balance:", amount);
    }
}
