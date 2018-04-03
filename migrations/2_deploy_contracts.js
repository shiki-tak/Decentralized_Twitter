var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var CryptoArticleToken = artifacts.require("./CryptoArticleToken.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(CryptoArticleToken, "CryptoArticleToken", "CAT");
};
