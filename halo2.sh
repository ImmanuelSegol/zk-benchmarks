#!/bin/bash

root="$(readlink -f "$(dirname "$0")")"/halo2-benchmarks/halo2_gadgets/
cd $root
cargo bench --bench poseidon
cd -
