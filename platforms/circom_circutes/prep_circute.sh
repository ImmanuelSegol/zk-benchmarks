#!/bin/bash

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
~/node/out/Release/node --trace-gc --trace-gc-ignore-scavenger --max-old-space-size=2048000 --initial-old-space-size=2048000 --no-global-gc-scheduling --no-incremental-marking --max-semi-space-size=1024 --initial-heap-size=2048000 --expose-gc ~/snarkjs/cli.js zkey new "$BUILD_DIR"/"$CIRCUIT_NAME".r1cs "$PHASE1" "$BUILD_DIR"/"$CIRCUIT_NAME"_0.zkey
end=`date +%s`
echo "DONE ($((end-start))s)"

echo "~~~GENERATING FINAL ZKEY~~~"
start=`date +%s`
~/node/out/Release/node --trace-gc --trace-gc-ignore-scavenger --max-old-space-size=2048000 --initial-old-space-size=2048000 --no-global-gc-scheduling --no-incremental-marking --max-semi-space-size=1024 --initial-heap-size=2048000 --expose-gc ~/snarkjs/cli.js zkey beacon "$BUILD_DIR"/"$CIRCUIT_NAME"_0.zkey "$BUILD_DIR"/"$CIRCUIT_NAME".zkey 0102030405060708090a0b0c0d0e0f101112231415161718221a1b1c1d1e1f 10 -n="Final Beacon phase2"
end=`date +%s`
echo "DONE ($((end-start))s)"

echo "~~~VERIFYING FINAL ZKEY~~~"
start=`date +%s`
~/node/out/Release/node --trace-gc --trace-gc-ignore-scavenger --max-old-space-size=2048000 --initial-old-space-size=2048000 --no-global-gc-scheduling --no-incremental-marking --max-semi-space-size=1024 --initial-heap-size=2048000 --expose-gc ~/snarkjs/cli.js zkey verify "$BUILD_DIR"/"$CIRCUIT_NAME".r1cs "$PHASE1" "$BUILD_DIR"/"$CIRCUIT_NAME".zkey
end=`date +%s`
echo "DONE ($((end-start))s)"

echo "~~~EXPORTING VERIFICATION KEY~~~"
start=`date +%s`
~/node/out/Release/node --trace-gc --trace-gc-ignore-scavenger --max-old-space-size=2048000 --initial-old-space-size=2048000 --no-global-gc-scheduling --no-incremental-marking --max-semi-space-size=1024 --initial-heap-size=2048000 --expose-gc ~/snarkjs/cli.js zkey export verificationkey "$BUILD_DIR"/"$CIRCUIT_NAME".zkey "$BUILD_DIR"/vkey.json
end=`date +%s`
echo "DONE ($((end-start))s)"