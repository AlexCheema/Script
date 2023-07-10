# How to deploy and test the circuits and contracts on Goerli
1. Set the correct .env vars: first copy .env.example and fill in the necessary values (private key, pool address, token addresses, goerli RPC). The vault address is output from the next step.
2. Deploy the StrategyVault:
`forge script contracts/scripts/StrategyVault.s.sol StrategyVault --broadcast --rpc-url goerli`
3. Take the address from this output (the second contract address output, the first is the verifier) and input into your .env as VAULT_ADDRESS.
4. Set up the necessary liquidity on the vault by transferring a sufficient amount of token0 and token1 to the vault address.
5. Initialize the LP on the vault:
`forge script contracts/scripts/InitializeMint.s.sol --broadcast --rpc-url goerli`
6. Generate the proofs by using the test from `index.js`. I did this by manually plugging in the values for the existing LP because TheGraph endpoint didn't seem to be indexing well (didn't see my positions).
7. Take the output `proof` and `publicSignals` (just big arrays of uint256s) and input them to `contracts/scripts/ExecuteStrategy.s.sol` in place of the existing `proof` and `publicSignals` variables.
8. Run the `execute` function to actually submit the proofs and execute the Actions.
`forge script contracts/scripts/ExecuteStrategy.s.sol --broadcast --rpc-url`

Confirmed tx-hash of this process on goerli: 0xccc19611ab01db3eb95ef98e7282332914283e58812f997c43a51fcc3eb0b476