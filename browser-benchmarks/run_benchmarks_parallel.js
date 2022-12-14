const puppeteer = require('puppeteer');
const { benchGroth16Circom } = require('./groth16Client');

const puppeteerBenchGroth16Circom = async (cap,circuitName) => {
    console.log("Starting test -->", cap['name'])
    
    cap['browserstack.username'] = process.env.BROWSERSTACK_USERNAME || 'YOUR_USERNAME';
    cap['browserstack.accessKey'] = process.env.BROWSERSTACK_ACCESS_KEY || 'YOUR_ACCESS_KEY';

    const browser = await puppeteer.connect({
      browserWSEndpoint:`wss://cdp.browserstack.com/puppeteer?caps=${encodeURIComponent(JSON.stringify(cap))}`,
    });

    const page = await browser.newPage();
    
    var filepath = path.join(__dirname, "./groth16Client");
    await page.addScriptTag({ path: require.resolve(filepath) });
    const benchmark_results = await page.evaluate(async (benchmarkFn, circuitName) => {
      return await benchmarkFn(circuitName);
    }, circuitName);
    
    console.log(benchmark_results, cap);
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
