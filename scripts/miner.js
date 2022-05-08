const Web3 = require("web3");
const axios = require("axios");
const colaAbi = require("./abi")

const ether_port = "ws://localhost:7545";
const web3 = new Web3(new Web3.providers.WebsocketProvider(ether_port));

const colaAddress = "0xEfEF4a123eAa2475a1Cb0343B7C085c90825E6E0";


const database = {
  "BTC/USD": ["https://api.pro.coinbase.com/products/BTC-USD/ticker"],
  "ETH/USD": ["https://api.pro.coinbase.com/products/ETH-USD/ticker"],
  "LTC/USD": [
    "https://api.binance.com/api/v1/klines?symbol=LTCUSDT&interval=1d&limit=1",
  ],
  "XRP/USD": [
    "https://api.binance.com/api/v1/klines?symbol=XRPUSDT&interval=1d&limit=1",
  ],
  "BNB/USD": [
    "https://dex.binance.org/api/v1/klines?symbol=BNB_USDSB-1AC&interval=1d&limit=1",
  ],
  "DOGE/USD": [
    "https://api.binance.com/api/v1/klines?symbol=DOGEUSDT&interval=1d&limit=1",
  ],
};

web3.eth.defaultAccount = web3.eth.accounts[0];

const colaContract = new web3.eth.Contract(colaAbi.colaAbi, colaAddress);

const account = web3.eth.accounts.privateKeyToAccount(
  "60fc130a01fb01e664d1eb83d0b3bb29c2544b6b0c632f20e83f1b437a13cc01"
);

console.log("MINER IS UP and READY TO MINE SOME COLA!");

colaContract.events.ColamoQueue({}, (error, event) => {
  console.log(event.returnValues);
  const name = event.returnValues.name;
  const requestUrl = database[name][0];
  axios.get(requestUrl).then((result) => {
    const apiResults = result.data;
    let finalData;
    switch (name) {
      case "BTC/USD":
        finalData = apiResults.price;
        break;
      case "ETH/USD":
        finalData = apiResults.price;
        break;
      case "LTC/USD":
        finalData = apiResults[0][4];
        break;
      case "BNB/USD":
        finalData = apiResults[0][4];
        break;
      case "DOGE/USD":
        finalData = apiResults[0][4];
        break;
    }
    console.log("data", finalData);
    colaContract.methods.updateValue(name, parseInt(finalData)).send(
      {
        from: account.address,
        gas: 200000,
      },
      (err, res) => {
        console.log(res, err);
      }
    );
  });
});
