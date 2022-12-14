const snarkjs = require("snarkjs");
const { getCircomBenchmarkFilesForCircuit } = require("./fileUtils");
const groth16 = require("./groth16Client");

async function main() {
    const { wasm, zkey, wtns, input } = getCircomBenchmarkFilesForCircuit("poseidonex_test");
    await groth16.generateWtns(input, wasm,wtns);
    const { proof, benchmark: p } = await groth16.prove(zkey, wtns);
    console.log(p)
    const { benchmark: v, isVerified } = await groth16.verify(zkey, proof);
    console.log(v, isVerified)
}

main().then(
    res => {
        console.log(res);
    },
    err => {
        console.error(err);
    }
);
