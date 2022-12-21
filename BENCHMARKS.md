# Benchmark results

All benchmark (excpet web benchmarks) are run on AWS r6i.8xlarge.
## Poseidon

 
### Groth16 - Circom

#### Desktop
| Platform | Prover time | Verifier time |
| -------- | -------- | -------- |
| Groth16 - snarkjs     | 0.910267 sec     | 0.787781 sec     |

#### Browser (https://www.browserstack.com/)

| Platform | Prover time | Verifier time |
| -------- | -------- | -------- |
| Groth16 - Chrome latest on Catalina     | 1.1015 sec     | 0.3255 sec     |
| Groth16 - Firefox latest on Catalina     | 1.375 sec     | 0.445 sec     |



### Halo2 (WIDTH = 12)

| Platform | Prover time | Verifier time |
| -------- | -------- | -------- |
| Halo2     | 0.13675 sec     | 0.0022623 sec     |



### Plonky 2 - Poseidon<GoldilocksField, 12>

| Platform | Prover time | Verifier time |
| -------- | -------- | -------- |
| Plonky 2     | 2.0804 µs (microseconds)     | TBA     |
