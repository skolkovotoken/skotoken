pragma solidity ^0.4.24;

import "./SafeMath.sol";
import "./SKOToken.sol";

contract SKOExchange {
  using SafeMath for uint256;

  address public owner;
  address public beneficiary;   // The beneficiary is the future recipient of the funds
  SKOToken public tokenReward;  // The token being sold
  uint public rate = 10000;     // The ratio of Token to Ether


  event FundTransfer(address _backer, uint _amount, bool _isContribution);
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  // Modifiers
  modifier onlyOwner() {
      require(msg.sender == owner,"Only the owner is allowed to call this.");
      _;
  }

  constructor(address _beneficiary, address tokenAddress, uint _rate) public{
    owner = msg.sender;
    beneficiary = _beneficiary;
    rate = _rate;
    tokenReward = SKOToken(tokenAddress);
  }


  function () public payable {
    // Update the sender's balance of wei contributed and the amount raised
    uint amount = msg.value;
    emit FundTransfer(msg.sender, amount, true);
  }

  // Any users can call this function to send their tokens and get Ethers
  function withdrawToken(uint tokensToWithdraw) public {
      uint tokensInWei = convertToMini(tokensToWithdraw);
      require(
          tokensInWei <= tokenReward.balanceOf(msg.sender),
          "You do not have sufficient balance to withdraw"
      );
      uint ethToGive = tokensInWei.div(rate);
      require(ethToGive <= address(this).balance, "Insufficient ethers.");
      //tokenReward.increaseApproval(address(this),tokensInWei);
      tokenReward.setAllowanceBeforeWithdrawal(msg.sender, address(this), tokensInWei);
      //tokenReward.transferFrom(msg.sender, tokenReward.owner(), tokensInWei);
      tokenReward.transferFrom(msg.sender, tokenReward.adminAddr(), tokensInWei);
      msg.sender.transfer(ethToGive);
      emit FundTransfer(this.owner(), ethToGive, true);
  }

  function sendEthers(uint ethersToSend) public onlyOwner {
    uint ethersToSendInWei = convertToMini(ethersToSend);
    require(ethersToSendInWei <= address(this).balance, "Insufficient ethers.");
    msg.sender.transfer(ethersToSendInWei);
    emit FundTransfer(this.owner(), ethersToSendInWei, true);
  }

  function convertToMini(uint amount) internal view returns (uint) {
      return amount * (10 ** uint(tokenReward.decimals()));
  }

  /**
  * @dev Allows the current owner to transfer control of the contract to a newOwner.
  * @param _newOwner The address to transfer ownership to.
  */
  function transferOwnership(address _newOwner) public onlyOwner {
      _transferOwnership(_newOwner);
  }

  /**
  * @dev Transfers control of the contract to a newOwner.
  * @param _newOwner The address to transfer ownership to.
  */
  function _transferOwnership(address _newOwner) internal {
      require(_newOwner != address(0), "Owner cannot be 0 address.");
      emit OwnershipTransferred(owner, _newOwner);
      owner = _newOwner;
  }

  /**
  * The owner can update the rate (CHP to ETH).
  *
  * @param _rate  the new rate for converting CHP to ETH
  */
  function setRate(uint _rate) public onlyOwner {
      //require(_rate >= LOW_RANGE_RATE && _rate <= HIGH_RANGE_RATE);
      rate = _rate;
  }
}