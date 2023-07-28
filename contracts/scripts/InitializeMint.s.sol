// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;

import "forge-std/Script.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "../src/StrategyVault.sol";

contract InitializeMintScript is Script {
    function setUp() public {}

    function run() public {
        address poolAddress = vm.envAddress("POOL_ADDRESS");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address vaultAddress = vm.envAddress("VAULT_ADDRESS");
        vm.startBroadcast(deployerPrivateKey);

        // 0x17c5f96a7ec66099a12622da2913face4ef83653
        StrategyVault(payable(vaultAddress)).mintLP(193020, 193080, 5500000, new bytes(0));
        // IUniswapV3Pool(poolAddress).mint(vaultAddress, 93060, 93120, 5500000, new bytes(0));
        vm.stopBroadcast();
    }
}
