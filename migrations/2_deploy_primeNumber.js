const PrimeNumberContract = artifacts.require("PrimeNumberLoot");

module.exports = function (deployer) {
  deployer.deploy(PrimeNumberContract);
};
