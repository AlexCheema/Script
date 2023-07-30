# Some Gotchas

* We have uint256s all over the place but most things dont need to be uint256, e.g. ticks are int24, actionType is a byte or less
* We use address(this) in the StrategyVault - would it actually be the smart contract that owns the liquidity positions? If the smart contract owns them, we need some mechanism to collect fees
* We assume we start with an already active position, since we submit a Burn
* Might be some issues with positive and negative numbers for "ticks" (int24's) and "amount" (int128) in Mint/Burn. Didn't check this thoroughly. Note that all numbers in the circuit are integers mod some big prime P
* We don't track price - we only track the tick. tickSpacing might be very large for certain pools so tick may not be granular enough.
* We currently execute optimistically, meaning if **anything** changes in our inputs we will revert. We probably want some tolerance for certain things, for example if price moves by ±0.01% that's probably fine.
* The strategy implemented is very simple - it simply tracks the current tick and keeps liquidity on there
* We don't track inventory - we might end up in a situation where we don't have enough of one token to provide liquidity (although we could control this through "availableLiquidity" - might want to change this to "tokenBalanceA" and "tokenBalanceB")
* Not sure if `tickSpacing` would actually be a signal. Also should it be public (probably)? But maybe in general for fixed parameters (`tickSpacing` is a fixed parameter for each pool) we could make it a template parameter (see [Templates in Circom](https://docs.circom.io/circom-language/templates-and-components/)).
* We don't use any non-trivial state right now. We might want to e.g. have volatility as an input. This would require either: an oracle like ChainLink OR something like Axiom that provides trustless aggregation of historical on-chain data OR a uniswap hook that calculates these and provides read access through a smart contract.