pragma circom 2.0.0;

template Burn() {
    signal input tickLower;
    signal input tickUpper;
    signal input amount;

    signal output action[4];

    assert(tickLower <= tickUpper);

    action[0] <== 2;
    action[1] <== tickLower;
    action[2] <== tickUpper;
    action[3] <== amount;
}
