pragma circom 2.0.0;

template Mint() {
    signal input tickLower;
    signal input tickUpper;
    signal input amount;

    signal output action[4];

    assert(tickLower <= tickUpper);
}
