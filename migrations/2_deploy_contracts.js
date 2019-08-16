var Token = artifacts.require("./SKOToken.sol");

Date.prototype.getUnixTime = function() {
  return (this.getTime() / 1000) | 0;
};

module.exports = function(deployer, network) {
  /* let admin, team;

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
  }); */

  var Contract = artifacts.require("./SKOExchange.sol");
  let beneficiary, tokenAddress, rate;

  if (network == "development") {
    //admin = accounts[1];
    //team = accounts[2];
  } else if (network == "rinkeby") {
    beneficiary = "0x936aDfb61B5bcBd1d1C8D466207fE181148b21EE";
    tokenAddress = "0xc50FaF095f068F770eE1B33d09DC33158E8f89F5";
    rate = "10000";
  } else if (network == "mainnet") {
    beneficiary = "0x704d40035E67F6F7BbeE18E0a931d5A28f974E74";
    tokenAddress = "0x741d63278490a33f705519cfd5c56fe470726ee8";
    rate = "10000";
  }

  deployer.deploy(Contract, beneficiary, tokenAddress, rate).then(function() {
    console.log("Contract deployed at: " + Contract.address);
  });
};
