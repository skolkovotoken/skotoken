var Token = artifacts.require("./SKOToken.sol");

Date.prototype.getUnixTime = function() {
  return (this.getTime() / 1000) | 0;
};

module.exports = function(deployer, network) {
  let admin, team;

  console.log("Deploying contracts on: " + network);
  if (network == "development") {
    //admin = accounts[1];
    //team = accounts[2];
  } else if (network == "rinkeby") {
    admin = "0x936aDfb61B5bcBd1d1C8D466207fE181148b21EE";
    team = "0xC1C13Ed18081b6b1a9f6CAa9e519cDc42b895C78";
  } else if (network == "mainnet") {
    admin = "0x1C6Aa15243df36cEc14B56387b7Bf9f16DFD462c";
    team = "0x704d40035E67F6F7BbeE18E0a931d5A28f974E74";
  }

  deployer.deploy(Token, admin, team).then(function() {
    console.log("Token deployed at: " + Token.address);
  });
};
