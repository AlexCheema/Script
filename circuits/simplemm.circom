pragma circom 2.0.0;

include "mint.circom";
include "burn.circom";

template SimpleMM() {
    // pool
    signal input currentTick;
    signal input tickSpacing;
    // user
    signal input myTick;
    signal input myLiquidity;
    signal input availableLiquidity;

    // signal input poolTick;
    // signal input myPositions;
    // signal input tokenABalance;
    // signal input tokenBBalance;

    signal output actions[8][4];

    assert(currentTick != myTick);

    var i = 0;

    component burn = Burn();
    burn.tickLower <== myTick;
    burn.tickUpper <== myTick + tickSpacing;
    burn.amount <== myLiquidity;
    actions[i] <== burn.action;
    i++;
    
    component mint = Mint();
    mint.tickLower <== currentTick;
    mint.tickUpper <== currentTick + tickSpacing;
    mint.amount <== availableLiquidity + myLiquidity;
    actions[i] <== mint.action;
    i++;
 }

 component main { public [currentTick, myTick, myLiquidity, availableLiquidity] } = SimpleMM();
