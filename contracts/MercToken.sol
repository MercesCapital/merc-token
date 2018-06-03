pragma solidity 0.4.19;

import 'openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol';

contract MercToken is BurnableToken {
  string public name = "MercesCapital";
  string public symbol = "MERC";
  uint8 public decimals = 18;
}