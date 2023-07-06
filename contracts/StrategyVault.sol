pragma solidity ^0.8.19;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "./Verifier.sol";

contract StrategyVault {
    address verifierContractAddress;
    address poolAddress;

    constructor(address _verifierContractAddress, address _poolAddress) {
        verifierContractAddress = _verifierContractAddress;
        poolAddress = _poolAddress;
    }

    function execute(uint256[24] calldata _proof, uint256[36] calldata _pubSignals) external returns (bool) {
        bool result = PlonkVerifier(verifierContractAddress).verifyProof(_proof, _pubSignals);
        require(result, "Invalid proof");

        // TODO: we need an optimistic check, i.e. if anything changed in the inputs we revert

        for (uint i = 0; i < 8; i++) {
            uint256 actionType = _pubSignals[i * 4];
            if (actionType == 0) break;

            if (actionType == 1) {
                int24 tickLower = int24(int256(_pubSignals[i * 4 + 1]));
                int24 tickUpper = int24(int256(_pubSignals[i * 4 + 2]));
                uint128 amount = uint128(_pubSignals[i * 4 + 3]);

                IUniswapV3Pool(poolAddress).mint(address(this), tickLower, tickUpper, amount, new bytes(0));
            }
            else if (actionType == 2) {
                int24 tickLower = int24(int256(_pubSignals[i * 4 + 1]));
                int24 tickUpper = int24(int256(_pubSignals[i * 4 + 2]));
                uint128 amount = uint128(_pubSignals[i * 4 + 3]);

                IUniswapV3Pool(poolAddress).burn(tickLower, tickUpper, amount);
            }
        }

        return true;
    }

}
