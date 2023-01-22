const { uploadFilesWithPublicAccess, deleteFiles } = require("./awss3");

async function deleteBenchmarkFiles(circitName) {
      const files = [
        {
            key: `${circitName}.wasm`
        },
        {
            key: `${circitName}.zkey`
        },
        {
            key: `${circitName}.json`
        }
      ];

      await deleteFiles(files);
}

async function uploadAndFetchFiles(circitName) {
    const wtns = `${circitName}_web.wtns`;
    const wasm = `../circomlib-benchmarks/benchmarks/${circitName}_benchmark_files/${circitName}_js/${circitName}.wasm`;
    const zkey = `../circomlib-benchmarks/benchmarks/${circitName}_benchmark_files/${circitName}.zkey`;
    const input = `../circomlib-benchmarks/benchmarks/inputs/${circitName}.json`;

    const files = [
        {
            path: wasm,
            key: `${circitName}.wasm`
        },
        {
            path: zkey,
            key: `${circitName}.zkey`
        },
        {
            path: input,
            key: `${circitName}.json`
        }
    ]
    
    const response = await uploadFilesWithPublicAccess(files);

    let aws_path_wasm = "";
    let aws_path_zkey = "";
    let aws_path_input = "";

    response.forEach(res => {
      switch (res.key) {
        case `${circitName}.wasm`:
          aws_path_wasm = res.Location;
          break;
        case `${circitName}.zkey`:
          aws_path_zkey = res.Location;
          break;
        case `${circitName}.json`:
          aws_path_input = res.Location;
          break;
        default:
          throw new Error(`cant match this key: ${res}`);
      }
    });


    console.log({
      wasm: aws_path_wasm,
      zkey: aws_path_zkey,
      input: aws_path_input,
      wtns,
  });
    return {
        wasm: aws_path_wasm,
        zkey: aws_path_zkey,
        input: aws_path_input,
        wtns,
    }
}


module.exports = {
  uploadAndFetchFiles
}
