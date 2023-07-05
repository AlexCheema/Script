const snarkjs = require("snarkjs");
const fs = require("fs");

async function run() {
    const { proof, publicSignals } = await snarkjs.plonk.fullProve({currentTick: 20, myTick: 21, availableLiquidity: 5}, "../circuits/simplemm_js/simplemm.wasm", "../circuits/simplemm_final.zkey");

    console.log("Proof: ");
    console.log(JSON.stringify(proof, null, 1));

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
