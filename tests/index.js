const snarkjs = require("snarkjs");
const fs = require("fs");
const { mapActions } = require("./action");

async function run() {
    const { proof, publicSignals } = await snarkjs.plonk.fullProve(
        { currentTick: 20, myTick: 21, myLiquidity: 8, availableLiquidity: 5 },
        "../circuits/simplemm_js/simplemm.wasm", "../circuits/simplemm_final.zkey"
    );

    const NUM_ACTIONS = 8;
    const actions = mapActions(publicSignals.slice(0, NUM_ACTIONS * 4));
    console.log(actions);

    const vKey = JSON.parse(fs.readFileSync("../circuits/verification_key.json"));
    const res = await snarkjs.plonk.verify(vKey, publicSignals, proof);

    if (res === true) {
        console.log("Verification OK");
    } else {
        console.log("Invalid proof");
    }

}

run().then(() => {
    process.exit(0);
});
