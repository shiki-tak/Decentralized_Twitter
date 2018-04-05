var DTweetToken = artifacts.require("./DTweetToken.sol");

module.exports = function(deployer) {
  deployer.deploy(DTweetToken, "DTweetToken", "CAT");
};
