pragma circom 2.0.0;

include "mint.circom";
include "burn.circom";

template SimpleMM() {
    signal input currentTick;
    signal input myTick;
    signal input myLiquidity;
    signal input availableLiquidity;
    signal output actions[8][4];

    var i = 0;

    assert(currentTick != myTick);

    component mint = Mint();
    mint.tickLower <== currentTick;
    mint.tickUpper <== currentTick;
    mint.amount <== availableLiquidity;
    actions[i] <== mint.action;
    i++;

    component burn = Burn();
    burn.tickLower <== myTick;
    burn.tickUpper <== myTick;
    burn.amount <== myLiquidity;
    actions[i] <== burn.action;
    i++;
 }

 component main = SimpleMM();
