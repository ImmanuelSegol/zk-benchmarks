#!/bin/bash

root="$(readlink -f "$(dirname "$0")")"/circomlib-benchmarks/benchmarks/
cd $root
sh bench_poseidonex.sh
cd -
