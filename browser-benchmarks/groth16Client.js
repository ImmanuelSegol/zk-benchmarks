const snarkjs = require("snarkjs");
const assert = require('assert');
const fs = require("fs");

function parseInputFile(inputFile) {
  let rawdata = fs.readFileSync(inputFile);
  return JSON.parse(rawdata);
}

async function generateWtns(inputFile, wasmFile, wtnsFile) {
  const input = parseInputFile(inputFile);
  await snarkjs.wtns.calculate(input, wasmFile, wtnsFile);
}

async function prove(zkey, wtnsFile) {
  const t0 = performance.now();
  const proof = await snarkjs.groth16.prove(zkey, "./" + wtnsFile);
  const t1 = performance.now();

  return {
    proof,
    benchmark: t1 - t0,
  }
}

async function verify(zkey, proof) {
  const vKey = await snarkjs.zKey.exportVerificationKey(zkey);

  const t0 = performance.now();
  const isVerified = await snarkjs.groth16.verify(vKey, proof.publicSignals, proof.proof);
  const t1 = performance.now();

  // program should fail if not valid proof
  assert(isVerified, "the proof seems to have not been veified");

  return {
    isVerified,
    benchmark: t1 - t0,
  }
}

async function benchGroth16Circom(circuitsName) {
    const { wasm, zkey, wtns, input } = getCircomBenchmarkFilesForCircuit(circuitsName);
    await generateWtns(input, wasm,wtns);
    const { proof, benchmark: proverTime } = await prove(zkey, wtns);
    const { benchmark: verifyTime, isVerified } = await verify(zkey, proof);

    return {
      proverTime,
      verifyTime,
      isVerified,
    }
}

module.exports = {
  generateWtns,
  prove,
  verify,
  benchGroth16Circom
}