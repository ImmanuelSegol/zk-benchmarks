#!/bin/bash

root="$(readlink -f "$(dirname "$0")")"/plonky2-bencmark/plonky2/benches/
cd $root
cargo bench --bench poseidon
cd -
