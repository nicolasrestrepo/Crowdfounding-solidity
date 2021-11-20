const CrowdFunding = artifacts.require("CrowdFunding"); // contract instance

module.exports = function (deployer) {
  deployer.deploy(CrowdFunding);
};