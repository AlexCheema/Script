// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;

import "forge-std/Script.sol";
import "../src/PlonkVerifier.sol";
import "../src/StrategyVault.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";

contract StrategyVaultScript is Script {
    function setUp() public {}

    function run() public {
        address poolAddress = vm.envAddress("POOL_ADDRESS");
        address token0Address = vm.envAddress("TOKEN0_ADDRESS");
        address token1Address = vm.envAddress("TOKEN1_ADDRESS");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        PlonkVerifier pv = new PlonkVerifier();
        StrategyVault sm =
        new StrategyVault(address(pv), poolAddress, IUniswapV3Pool(poolAddress).tickSpacing(), token0Address, token1Address);

        vm.stopBroadcast();
    }
}
