const PrimeNumberContract = artifacts.require("PrimeNumber");

module.exports = function (deployer) {
  deployer.deploy(PrimeNumberContract);
};
