// TODO: we can set the circuit we're using in a variable and have that propagate down to
// all of these variable names
const snarkjs = require("snarkjs");

export async function generateProof(input, proofType) {  
  const t0 = performance.now();
  const { proof, publicSignals } = await snarkjs.groth16.fullProve(
    input,
    `../${proofType.filename}.wasm`,
    `${proofType.filename}.zkey`
  );
  const t1 = performance.now();

  const benchmark_msg = "generating proof took: " + (t1 - t0) + " milliseconds.";

  return {
    proof,
    publicSignals,
    benchmark_msg,
  };
}

export async function verifyProof(
  proof,
  publicSignals,
  proofType,
) {
  const t0 = performance.now();
  const proofVerified = await snarkjs.groth16.verify(
    JSON.parse(proofType.vkey),
    publicSignals,
    proof
  );
  const t1 = performance.now();
  const benchmark_msg = "verifying proof took: " + (t1 - t0) + " milliseconds.";

  return { 
    proofVerified, 
    benchmark_msg 
  };
}
