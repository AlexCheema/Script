const snarkjs = require("snarkjs");
const fs = require("fs");
const { mapActions } = require("./action");
const { getPoolState } = require("./pool");

async function run() {
    const state = await getPoolState("0x6337b3caf9c5236c7f3d1694410776119edaf9fa", "0x54f3a4f7a85c70c0c0e99f42f92b0ac34a18c534");

    if (state.positions.length > 1) {
        throw new Error(`This strategy only handles up to 1 existing liquidity position but found ${state.positions.length}`);
    }

    const { proof, publicSignals } = await snarkjs.plonk.fullProve(
        {
            currentTick: state.tick,
            tickSpacing: state.tickSpacing,

            myTick: state.positions?.[0]?.tickLower?.tickIdx ?? "0",
            myLiquidity: state.positions?.[0]?.liquidity ?? "0",
            availableLiquidity: "1000000"
        },
        "../circuits/simplemm_js/simplemm.wasm", "../circuits/simplemm_final.zkey"
    );

    // Convert the data into Solidity calldata that can be sent as a transaction
    const calldataBlob = await snarkjs.plonk.exportSolidityCallData(proof, publicSignals);
    const calldata = calldataBlob.split(',');
    console.log("Calldata parsed", calldata);

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
