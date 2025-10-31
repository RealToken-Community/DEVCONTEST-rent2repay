// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Rent2Repay} from "../../src/Rent2Repay.sol";

contract GrantRevokeRole is Script {
    function run() external {
        address r2rProxyAddr = vm.envAddress("R2R_PROXY_ADDR");
        uint256 adminPk = vm.envUint("PRIVATE_KEY"); // détenteur actuel du rôle admin défaut
        uint256 user1Pk = vm.envUint("USER1_KEY");
        address adminAddr = vm.addr(adminPk);
        address user1Addr = vm.addr(user1Pk);

        console.log("=== GRANT/REVOKE ADMIN_ROLE TEST ===");
        console.log("R2R Proxy:", r2rProxyAddr);
        console.log("Admin (PRIVATE_KEY):", adminAddr);
        console.log("User1 (USER1_KEY):", user1Addr);

        Rent2Repay r2r = Rent2Repay(r2rProxyAddr);

        // 1) Grant ADMIN_ROLE to USER1 from DEFAULT_ADMIN/ADMIN holder
        vm.startBroadcast(adminPk);
        bool hasAdminAfterGrant = r2r.hasRole(r2r.ADMIN_ROLE(), user1Addr);
        console.log("USER1 has ADMIN_ROLE?", hasAdminAfterGrant);
        r2r.grantRole(r2r.ADMIN_ROLE(), user1Addr);
        console.log("Granted ADMIN_ROLE to USER1");
        hasAdminAfterGrant = r2r.hasRole(r2r.ADMIN_ROLE(), user1Addr);
        console.log("USER1 has ADMIN_ROLE?", hasAdminAfterGrant);
        vm.stopBroadcast();

        // 2) From USER1, call updateDaoFeeReductionMinimumAmount(10)
        vm.startBroadcast(user1Pk);
        r2r.updateDaoFeeReductionMinimumAmount(10);
        console.log("Called updateDaoFeeReductionMinimumAmount(10) from USER1");
        {
            (, uint256 minimumAmount,,) =
                r2r.getDaoFeeReductionConfiguration();
            console.log("DaoFeeReduction minimumAmount:", minimumAmount);
        }
        vm.stopBroadcast();

        // 3) Revoke ADMIN_ROLE from USER1 by admin
        vm.startBroadcast(adminPk);
        r2r.revokeRole(r2r.ADMIN_ROLE(), user1Addr);
        console.log("Revoked ADMIN_ROLE from USER1");
        bool hasAdminAfterRevoke = r2r.hasRole(r2r.ADMIN_ROLE(), user1Addr);
        console.log("USER1 has ADMIN_ROLE?", hasAdminAfterRevoke);
        vm.stopBroadcast();
    }
}


