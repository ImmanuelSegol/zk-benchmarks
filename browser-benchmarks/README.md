# Usage
Enviroment setup
 - Create a free Browserstack account.
 - Create a `.env` file with the following variables:
 ```
BROWSERSTACK_USERNAME=...
BROWSERSTACK_ACCESS_KEY=...

AWS_ACCESS_KEY_ID=...
SECRET_ACCESS_KEY=...
SNARKJS_WEB_SITE=<a website that has snarkjs as a dependency>
 ```
- `npm i`
- `npm run bench:groth16`
- See results in terminal.
