const Web3 = require("web3");
const colaAbi = require("./abi");

const web3 = new Web3(
  new Web3.providers.WebsocketProvider("ws://127.0.0.1:7545")
);

const colaAddress = "0xEfEF4a123eAa2475a1Cb0343B7C085c90825E6E0";
const colaContract = new web3.eth.Contract(colaAbi.colaAbi, colaAddress);
const account = web3.eth.accounts.privateKeyToAccount(
  "60fc130a01fb01e664d1eb83d0b3bb29c2544b6b0c632f20e83f1b437a13cc01"
);
web3.eth.defaultAccount = account.address;

colaContract.methods.mint("1000").call({}, (err, res) => console.log(err, res));
