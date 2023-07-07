// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;

import "forge-std/Script.sol";
import "../src/PlonkVerifier.sol";
import "../src/StrategyVault.sol";

contract StrategyVaultScript is Script {
    function setUp() public {}

    function run() public {
        address poolAddress = vm.envAddress("POOL_ADDRESS");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        PlonkVerifier pv = new PlonkVerifier();
        StrategyVault sm = new StrategyVault(address(pv), poolAddress);

        vm.stopBroadcast();
    }
}
