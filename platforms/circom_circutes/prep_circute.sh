#!/bin/bash

PTAU_FILE=ptau/powersOfTau28_hez_final_14.ptau

echo $PWD

echo "~~~COMPILING CIRCUIT~~~"
start=`date +%s`
circom "$1" --r1cs --sym --c --output .
end=`date +%s`
echo "DONE ($((end-start))s)"

echo "~~~GENERATING WITNESS FOR~~~"
start=`date +%s`
x="$1"
circuit_name=${x%.*}
set -x
cd "$circuit_name"_cpp 
make
./"$circuit_name" ../inputs/"$circuit_name".json ../"$circuit_name"_witness.wtns > ../log.out
cd ..
end=`date +%s`
echo "DONE ($((end-start))s)"

echo "~~~GENERATING ZKEY 0~~~"
start=`date +%s`
node --trace-gc --trace-gc-ignore-scavenger --max-old-space-size=2048000 --initial-old-space-size=2048000 --no-global-gc-scheduling --no-incremental-marking --max-semi-space-size=1024 --initial-heap-size=2048000 --expose-gc /home/ubuntu/monia/benchmark/platforms/node_modules/snarkjs/cli.js zkey new ./"$circuit_name".r1cs "$PTAU_FILE" ./"$circuit_name"_0.zkey
end=`date +%s`
echo "DONE ($((end-start))s)"

echo "~~~GENERATING FINAL ZKEY~~~"
start=`date +%s`
node --trace-gc --trace-gc-ignore-scavenger --max-old-space-size=2048000 --initial-old-space-size=2048000 --no-global-gc-scheduling --no-incremental-marking --max-semi-space-size=1024 --initial-heap-size=2048000 --expose-gc /home/ubuntu/monia/benchmark/platforms/node_modules/snarkjs/cli.js zkey beacon ./"$circuit_name"_0.zkey ./"$circuit_name".zkey 0102030405060708090a0b0c0d0e0f101112231415161718221a1b1c1d1e1f 10 -n="Final Beacon phase2"
end=`date +%s`
echo "DONE ($((end-start))s)"

echo "~~~VERIFYING FINAL ZKEY~~~"
start=`date +%s`
node --trace-gc --trace-gc-ignore-scavenger --max-old-space-size=2048000 --initial-old-space-size=2048000 --no-global-gc-scheduling --no-incremental-marking --max-semi-space-size=1024 --initial-heap-size=2048000 --expose-gc /home/ubuntu/monia/benchmark/platforms/node_modules/snarkjs/cli.js zkey verify ./"$circuit_name".r1cs "$PTAU_FILE" ./"$circuit_name".zkey
end=`date +%s`
echo "DONE ($((end-start))s)"

echo "~~~EXPORTING VERIFICATION KEY~~~"
start=`date +%s`
node --trace-gc --trace-gc-ignore-scavenger --max-old-space-size=2048000 --initial-old-space-size=2048000 --no-global-gc-scheduling --no-incremental-marking --max-semi-space-size=1024 --initial-heap-size=2048000 --expose-gc /home/ubuntu/monia/benchmark/platforms/node_modules/snarkjs/cli.js zkey export verificationkey ./"$circuit_name".zkey ./"$circuit_name"_vkey.json
end=`date +%s`
echo "DONE ($((end-start))s)"

echo "****GENERATING PROOF FOR SAMPLE INPUT****"
start=`date +%s`
npx snarkjs groth16 prove ./"$circuit_name".zkey ./"$circuit_name"_witness.wtns ./"$circuit_name"_proof.json ./"$circuit_name"_public.json
end=`date +%s`
echo "DONE ($((end-start))s)"

echo "****VERIFYING PROOF FOR SAMPLE INPUT****"
start=`date +%s`
npx snarkjs groth16 verify ./"$circuit_name"_vkey.json ./"$circuit_name"_public.json ./"$circuit_name"_proof.json
end=`date +%s`
echo "DONE ($((end-start))s)"