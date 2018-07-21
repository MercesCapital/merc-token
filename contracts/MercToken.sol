pragma solidity ^0.4.21;

import "openzeppelin-solidity/token/ERC20/BurnableToken.sol";
import "openzeppelin-solidity/ownership/Ownable.sol";

contract MercToken is BurnableToken, Ownable {
  string public name = "MercesCapital";
  string public symbol = "MERC";
  uint8 public decimals = 18;
  
  // Initial Supply of 100,000,000 MERC tokens.
  uint256 public totalSupply_ = 100000000;
}
