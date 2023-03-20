# Latest Benchmark results
[Results](https://github.com/ImmanuelSegol/zk-benchmarks/blob/main/BENCHMARKS.md)

# Development and usage
Enviroment setup
- install [rust](https://www.rust-lang.org/tools/install)
  - https://rust-lang.github.io/rustup/installation/index.html#installing-nightly
- install [circom](https://docs.circom.io/getting-started/installation/#installing-circom)

### MacOS - 
I found that you might need to install nlohmann
```
brew install nlohmann-json
```


## Usage
- Install the dependencies above.
- `git submodule update --init`
- run `sh setup.sh`
- run any of the benchmark files.


### Development Notes
- Dont name your folder *_benchmark_files/ as these are .gitignored, and deleted with the clean up script.
etaadadsa
