const puppeteer = require('puppeteer');
const { generateProof } = require('./grothClient');

const bench = async (cap, benchmarkFn) => {
    console.log("Starting test -->", cap['name'])
    
    cap['browserstack.username'] = process.env.BROWSERSTACK_USERNAME || 'YOUR_USERNAME';
    cap['browserstack.accessKey'] = process.env.BROWSERSTACK_ACCESS_KEY || 'YOUR_ACCESS_KEY';

    const browser = await puppeteer.connect({
      browserWSEndpoint:`wss://cdp.browserstack.com/puppeteer?caps=${encodeURIComponent(JSON.stringify(cap))}`,
    });
    
    const page = await browser.newPage();
    const benchmark_results = await page.evaluate(() => benchmarkFn());
    console.log(benchmark_results);
    await browser.close();
};


const capabilities = [
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

const tt = async (cap, benchmarkFn) => {}


capabilities.forEach(async (cap) => {
  //await bench(cap);
  await generateProof()
});
