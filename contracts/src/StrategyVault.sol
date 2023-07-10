// SPDX-License-Identifier: UNLICENSED
// This was needed for deploying UniV3 pool, would be good to update when possible
pragma solidity ^0.7.6;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/interfaces/callback/IUniswapV3MintCallback.sol";
import "./PlonkVerifier.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract StrategyVault is IUniswapV3MintCallback {
    using SafeMath for uint256;

    address public verifierContractAddress;
    address public poolAddress;
    uint256 public poolTickSpacing;
    address public token0Address;
    address public token1Address;

    constructor(
        address _verifierContractAddress,
        address _poolAddress,
        int24 _poolTickSpacing,
        address _token0Address,
        address _token1Address
    ) {
        verifierContractAddress = _verifierContractAddress;
        poolAddress = _poolAddress;
        poolTickSpacing = uint256(int256(_poolTickSpacing));
        token0Address = _token0Address;
        token1Address = _token1Address;
    }

    function verifyActions(uint256[24] calldata _proof, uint256[36] calldata _pubSignals) public view {
        bool result = PlonkVerifier(verifierContractAddress).verifyProof(_proof, _pubSignals);
        require(result, "Invalid proof");

        // TODO: we need an optimistic check, i.e. if anything changed in the inputs we revert
        // * currentTick - DONE (see below require)
        // * myTick
        // * myLiquidity
        // * availableLiquidity (note: we might want to change this for tokenBalanceA and tokenBalanceB)
        (, int24 tick,,,,,) = IUniswapV3Pool(poolAddress).slot0();
        require(tick >= 0, "Cannot convert negative value to Uint256");
        uint256 alignedTick = uint256(int256(tick)) / poolTickSpacing * poolTickSpacing;
        require(alignedTick == _pubSignals[32], "Tick changed");
    }

    function execute(uint256[24] calldata _proof, uint256[36] calldata _pubSignals) external returns (bool) {
        verifyActions(_proof, _pubSignals);

        for (uint256 i = 0; i < 8; i++) {
            uint256 actionType = _pubSignals[i * 4];
            if (actionType == 0) break;

            if (actionType == 1) {
                int24 tickLower = int24(int256(_pubSignals[i * 4 + 1]));
                int24 tickUpper = int24(int256(_pubSignals[i * 4 + 2]));
                uint128 amount = uint128(_pubSignals[i * 4 + 3]);

                IUniswapV3Pool(poolAddress).mint(address(this), tickLower, tickUpper, amount, new bytes(0));
            } else if (actionType == 2) {
                int24 tickLower = int24(int256(_pubSignals[i * 4 + 1]));
                int24 tickUpper = int24(int256(_pubSignals[i * 4 + 2]));
                uint128 amount = uint128(_pubSignals[i * 4 + 3]);

                IUniswapV3Pool(poolAddress).burn(tickLower, tickUpper, amount);
            }
        }

        return true;
    }

    // To mint an LP from the vault's address using its owned ERC20 liquidity
    function mintLP(int24 tickLower, int24 tickUpper, uint128 amount, bytes calldata data) public {
        IUniswapV3Pool(poolAddress).mint(address(this), tickLower, tickUpper, amount, data);
    }

    receive() external payable {}

    function uniswapV3MintCallback(uint256 amount0Owed, uint256 amount1Owed, bytes calldata data) external override {
        if (amount0Owed > 0) {
            IERC20(token0Address).transfer(msg.sender, amount0Owed);
        }
        if (amount1Owed > 0) {
            IERC20(token1Address).transfer(msg.sender, amount1Owed);
        }
    }
}
