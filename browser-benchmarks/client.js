// TODO: we can set the circuit we're using in a variable and have that propagate down to
// all of these variable names
const snarkjs = require("snarkjs");

export function bench() {
    setTimeout(() => console.log('reeee'), 10);
}

export async function generateProof(input, proofType) {
  console.log("generating proof for input");
  console.log(input);
  const { proof, publicSignals } = await snarkjs.groth16.fullProve(
    input,
    `../${proofType.filename}.wasm`,
    `${proofType.filename}.zkey`
  );
  console.log(`Generated proof ${JSON.stringify(proof)}`);

  return {
    proof,
    publicSignals,
  };
}

export async function verifyProof(
  proof,
  publicSignals,
  proofType,
) {
  const proofVerified = await snarkjs.groth16.verify(
    JSON.parse(proofType.vkey),
    publicSignals,
    proof
  );

  return proofVerified;
}
