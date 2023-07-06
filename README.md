# Script

1. Install circom and snarkjs [here](https://docs.circom.io/getting-started/installation/)
2. Run [generate.sh](./circuits/generate.sh) in [circuits](./circuits)
3. Run `npm install` in [tests](./tests)
4. Run `npm run test` in [tests](./tests)

## Tradeoffs

* We use address(this) in the StrategyVault - would it actually be the smart contract that owns the liquidity positions? If the smart contract owns them, we need some mechanism to collect fees
* We assume we start with an already active position, since we submit a Burn
* Might be some issues with positive and negative numbers for "amount" in Mint/Burn. Didn't check this thoroughly. Note that all numbers in the circuit are integers mod some big prime P
* We don't track price - we only track the tick. tickSpacing might be very large for certain pools so tick may not be granular enough.
* We currently execute optimistically, meaning if **anything** changes in our inputs we will revert. We probably want some tolerance for certain things, for example if price moves by ±0.01% that's probably fine.
* The strategy implemented is very simple - it simply tracks the current tick and keeps liquidity on there
* We don't track inventory - we might end up in a situation where we don't have enough of one token to provide liquidity (although we could control this through "availableLiquidity" - might want to change this to "tokenBalanceA" and "tokenBalanceB")
* Not sure if `tickSpacing` would actually be a signal. Also should it be public (probably)? But maybe in general for fixed parameters (`tickSpacing` is a fixed parameter for each pool) we could make it a template parameter (see [Templates in Circom](https://docs.circom.io/circom-language/templates-and-components/)).