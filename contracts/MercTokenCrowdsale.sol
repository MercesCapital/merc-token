pragma solidity ^0.4.21;

import "./MercToken.sol";
import "openzeppelin-solidity/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol";

contract MercTokenCrowdsale is TimedCrowdsale {

  constructor (
    uint256 _openingTime, 
    uint _closingTime, 
    uint256 _rate, 
    address _wallet, 
    ERC20 _token
  )

    public 
    Crowdsale(_rate, _wallet, _token)
    TimedCrowdsale(_openingTime, _closingTime) 
  {

  }

}