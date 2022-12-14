# download ptau files for groth16
root="$(readlink -f "$(dirname "$0")")"/circomlib-benchmarks/benchmarks/ptau/
cd $root
sh download_ptau.sh 14
cd -

# npm install
cd "$(readlink -f "$(dirname "$0")")"/circomlib-benchmarks/
npm i
cd -

# npm install
cd "$(readlink -f "$(dirname "$0")")"/circomlib-benchmarks/
npm i
cd -

cd "$(readlink -f "$(dirname "$0")")"/browser-benchmarks/
npm i
cd -

echo "setup complete"
