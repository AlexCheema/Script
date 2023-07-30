// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;

import "forge-std/Script.sol";
import "../src/StrategyVault.sol";

contract ExecuteStrategyScript is Script {
    uint256[24] proof = [
        0x2644e9c4701fdbd0809111c5304460ba0bca4dd9d444f08ae5fa347d3ca89955,
        0x07b2e9938c1f773994561e5d8b425f78d95a5b84bcddb7fcc5f682136f127225,
        0x296f6320c67998fcdc068777ed42a753235c70a0acf12c4265c511492d464cf7,
        0x18a64a0f7cf9a755c33a973f9d5645b22d7950f3dac7e03f19524f0cc71beb3e,
        0x107c63c19f580e6446bb4689e6c783548a003f5431009032fe5401d7e1b7fc42,
        0x17d9c615f2cd8cd6ad73b5525a576de09b9245d74e63a24ca30a672a0aa6aa2d,
        0x152aa9450db911832e01ddef941cf8cadbdabf7669860dd2466cab707a37ea5a,
        0x03cd4636d33715fb105532412f2d3115f3912d6d9f1db4183f261fa1bb7f93c2,
        0x26a50a2e1c4e8e30dfc705efe469df50f05caa041b9030a4111561140295fd08,
        0x24fefd20538901e4fcc63fa412f8dbc607caec6377a799959636eefb107810be,
        0x12ef8cf9f9db5086bbbb1bab1b1a7e05bebf85951c940c94fba2165eb842a50b,
        0x1c6342253cf567ad8f5cddf746b361926fef2d8014c42503fb96dcf51a7f4a03,
        0x0485780cc4554fe4dde5b6fe30d4eaa2842bc041f64f1e0d74ad841a8e9ebf4e,
        0x08a283d098a6946d6d2b9370d1ff0a3faf45a0734df1146c396fd0e92d39752b,
        0x0e43d6b5e0b4f3443b2675fda9ecbd808f39b48e520f8317b8220311f66a19ef,
        0x26636fa0bb919de4c52b54ce2fa316dd49d5a7842f4609ffeb1120166e28d84a,
        0x0699cf1a12a6da9113fe79a342fe85753c846f4f06f61f42e143e5e01cc95df4,
        0x0f9c10d9a48fa7f9ebca1ad10b90933bc8697d0bdef9e348fc6244550894b0e2,
        0x13c57c30bf2cba79893e2d7fb75562d7e434c7f759b6b5bb10584bd81ab1c503,
        0x1a51c4eb83f6f96f56311ce3891342c13e7fd15fd14f6364c71fe5000f2380c9,
        0x2e5d5813fe43aee33fd8f252c2888a19bae8fd8fadeaca80ed34c7e38195387f,
        0x0e82564c17f890de4e88dde5ec671d71dc0befa426cdde457a6fbe2dc59ec08e,
        0x2eca12b554516c8314735a921e7747431066b9f2e4ed5d4d1915eda76e0ce567,
        0x02f4f54ab93bcfdf06f6cf7f113238300050c1c9f6d1acae9510030bd1dd4daa
    ];

    uint256[36] publicSignals = [
        0x0000000000000000000000000000000000000000000000000000000000000002,
        0x000000000000000000000000000000000000000000000000000000000002f1fc,
        0x000000000000000000000000000000000000000000000000000000000002f238,
        0x000000000000000000000000000000000000000000000000000000000053ec60,
        0x0000000000000000000000000000000000000000000000000000000000000001,
        0x0000000000000000000000000000000000000000000000000000000000016b48,
        0x0000000000000000000000000000000000000000000000000000000000016b84,
        0x0000000000000000000000000000000000000000000000000000000000632ea0,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000000000,
        0x0000000000000000000000000000000000000000000000000000000000016b48,
        0x000000000000000000000000000000000000000000000000000000000002f1fc,
        0x000000000000000000000000000000000000000000000000000000000053ec60,
        0x00000000000000000000000000000000000000000000000000000000000f4240
    ];

    function setUp() public {}

    function run() public {
        address poolAddress = vm.envAddress("POOL_ADDRESS");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address vaultAddress = vm.envAddress("VAULT_ADDRESS");
        vm.startBroadcast(deployerPrivateKey);

        StrategyVault(payable(vaultAddress)).execute(proof, publicSignals);

        vm.stopBroadcast();
    }
}