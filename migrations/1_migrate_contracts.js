var bep20 = artifacts.require("./BEP20Token.sol");
var ctx = artifacts.require("./Context.sol");
var ibep20 = artifacts.require("./IBEP20.sol");

module.exports = function (deployer) {
  deployer.deploy(bep20, { gas: 5000000 }).then(function () {
    console.log("********* bep20 is deployed! *********");
  });
};
