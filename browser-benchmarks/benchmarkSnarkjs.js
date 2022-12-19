const puppeteer = require('puppeteer');
const { getCircomBenchmarkFilesForCircuit } = require('./fileUtils');

const puppeteerBenchGroth16Circom = async (cap,circuitName) => {
    console.log("Starting test -->", cap['name'])
    
    cap['browserstack.username'] = process.env.BROWSERSTACK_USERNAME || 'YOUR_USERNAME';
    cap['browserstack.accessKey'] = process.env.BROWSERSTACK_ACCESS_KEY || 'YOUR_ACCESS_KEY';
    cap["browserstack.console"] = "verbose";

    const browser = await puppeteer.connect({
      browserWSEndpoint:
      `wss://cdp.browserstack.com/puppeteer?caps=${encodeURIComponent(JSON.stringify(cap))}`,  // The BrowserStack CDP endpoint gives you a `browser` instance based on the `caps` that you specified
    });


    const page = await browser.newPage();
    await page.goto(process.env.SNARKJS_WEB_SITE || "https://immanuelsegol.github.io/");
    
    // wait for title to load 
    await page.title();
    
    const paths = await getCircomBenchmarkFilesForCircuit(circuitName);


    const benchmark_results = await page.evaluate(async (files) => {
        async function parseInputFile(inputFile) {
          const response = await fetch(inputFile, { method: 'GET'});
          const json = await response.json();
          return json
      }
      
      async function generateWtns(inputFile, wasmFile, wtnsFile) {
        console.log("Generating wtns");
        const input = await parseInputFile(inputFile);
        console.log(`Input: ${JSON.stringify(input)}`);
        try {
          await snarkjs.wtns.calculate(input, wasmFile, wtnsFile);
        } catch (error) {
          throw error;
        }

        console.log("Completed generating wtns");
      }
      
      async function prove(zkey, wtnsFile) {
        console.log("Starting prover");
        const t0 = performance.now();
        const proof = await snarkjs.groth16.prove(zkey, wtnsFile);
        const t1 = performance.now();
        
        console.log("Prover done");
        return {
          proof,
          benchmark: t1 - t0,
        }
      }
      
      async function verify(zkey, proof) {
        console.log("Starting verifier");
        const vKey = await snarkjs.zKey.exportVerificationKey(zkey);
      
        const t0 = performance.now();
        const isVerified = await snarkjs.groth16.verify(vKey, proof.publicSignals, proof.proof);
        const t1 = performance.now();
      
        // program should fail if not valid proof
        if (isVerified === false) {
          throw new Error("the proof seems to have not been veified");
        }
        
        console.log("Verifier done");
        return {
          isVerified,
          benchmark: t1 - t0,
        }
      }
      
      
      const { wasm, zkey, input } = files;

      const wtns= {
        type: "mem"
      };

      await generateWtns(input, wasm,wtns);
      const { proof, benchmark: proverTime } = await prove(zkey, wtns);
      const { benchmark: verifyTime, isVerified } = await verify(zkey, proof);
      
      return {
        proverTime,
        verifyTime,
        isVerified,
      }
    }, paths);

    console.log("Benchmark results");
    console.log(benchmark_results, cap);
    console.log("Benchmark results");
    await browser.close();
};


const benches = [
  {
    prover: "groth16",
    lang: "circom",
    circuit: "poseidonex_test",
  }
]

const platforms = [
{
  'browser': 'chrome',
  'browser_version': 'latest',
  'os': 'osx',
  'os_version': 'catalina',
  'name': 'Chrome latest on Catalina',
  'build': 'puppeteer-build-2'
},
{
  'browser': 'firefox',
  'browser_version': 'latest',
  'os': 'osx',
  'os_version': 'catalina',
  'name': 'Firefox latest on Catalina',
  'build': 'puppeteer-build-2'
}]

benches.forEach(b => {
  switch (b.prover) {
    case "groth16":
      platforms.forEach(async (cap) => {
        await puppeteerBenchGroth16Circom(cap, b.circuit);
      });
      return
    default:
      throw new Error(`bench for ${b.prover} not implemented`);
  }
})
