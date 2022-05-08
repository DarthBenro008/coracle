const prompts = require("prompts");
const Web3 = require("web3");
const colaAbi = require("./abi");

const web3 = new Web3(
  new Web3.providers.WebsocketProvider("ws://127.0.0.1:7545")
);

const colaAddress = "0xEfEF4a123eAa2475a1Cb0343B7C085c90825E6E0";

web3.eth.defaultAccount = web3.eth.accounts[0];

const colaContract = new web3.eth.Contract(colaAbi.colaAbi, colaAddress);
const account = web3.eth.accounts.privateKeyToAccount(
  "60fc130a01fb01e664d1eb83d0b3bb29c2544b6b0c632f20e83f1b437a13cc01"
);

console.log("CONSUMER IS UP!");

prompts([
  {
    type: "select",
    name: "value",
    message: "Pick a value you'd like to request dynamic pricing of!",
    choices: [
      { title: "BTC/USD", value: "BTC/USD" },
      { title: "BNB/USD", value: "BNB/USD" },
      { title: "XRP/USD", value: "XRP/USD" },
      { title: "ETH/USD", value: "ETH/USD" },
      { title: "DOGE/USD", value: "DOGE/USD" },
      { title: "LTC/USD", value: "LTC/USD" },
    ],
    initial: 0,
  },
]).then((requestUpdateFor) => {
  console.log("Requested update for: ", requestUpdateFor);
  colaContract.methods.addQueue(requestUpdateFor.value).send(
    {
      from: account.address,
      gas: 200000,
    },
    (_, res) => {
      console.log(res);
      colaContract.events.ColamoUpdated(
        {
          filter: { name: requestUpdateFor.value },
        },
        (_, event) => {
          console.log(event.returnValues);
        }
      );
    }
  );
});
