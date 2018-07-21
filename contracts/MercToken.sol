pragma solidity ^0.4.21;

import "openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";

contract MercToken is BurnableToken {
  string public name = "MercesCapital";
  string public symbol = "MERC";
  uint8 public decimals = 18;
  
  // Initial Supply of 100,000,000 MERC tokens.
  uint256 public totalSupply_ = 100000000;
}
