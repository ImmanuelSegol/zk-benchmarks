function getCircomBenchmarkFilesForCircuit(circitName) {
    const wasm = `../circomlib-benchmarks/benchmarks/${circitName}_benchmark_files/${circitName}_js/${circitName}.wasm`;
    const zkey = `../circomlib-benchmarks/benchmarks/${circitName}_benchmark_files/${circitName}.zkey`;
    const wtns = `${circitName}_web.wtns`;
    const input = `../circomlib-benchmarks/benchmarks/inputs/${circitName}.json`;


    return {
        wasm,
        zkey,
        wtns,
        input,
    }
}

module.exports = {
    getCircomBenchmarkFilesForCircuit
}