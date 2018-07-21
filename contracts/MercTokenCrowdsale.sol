pragma solidity ^0.4.21;

import "./MercToken.sol";
import "openzeppelin-solidity/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/crowdsale/distribution/FinalizableCrowdsale.sol";
import "openzeppelin-solidity/crowdsale/validation/PostDeliveryCrowdsale.sol";

contract MercTokenCrowdsale is FinalizableCrowdsale, PostDeliveryCrowdsale, Ownable {

    uint8 public constant decimals = 18;

    // There are 100,000,000 MERC Tokens
    uint256 public maxCrowdSaleTokens = 70000000 * (10 ** uint256(decimals)); // 100 Million Tokens 
    uint256 public tierOneTokens = 7000000 * (10 ** uint256(decimals)); // 7 Million MERC tokens will be sold during tierOne portion of sale
    uint256 public tierTwoTokens = 10500000 * (10 ** uint256(decimals)); // 10.5 Million MERC tokens will be sold duing tierTwo portion of sale
    uint256 public preSaleTokens = 17500000 * (10 ** uint256(decimals)); // 17.5 Million MERC of tokens will be sold during private and pre-sale
    // uint256 public privateSaleTokens = 35000000 * (10 ** uint256(decimals)); // 35% of tokens will be sold during private and pre-sale
    uint256 public publicSaleTokens = 35000000 * (10 ** uint256(decimals)); // 35% of Tokens will be sold during public crowdsale
    uint256 public teamTokens = 30000000 * (10 ** uint256(decimals)); // 30% of Tokens will be given to Team, Consultants, Advisors, etc

    uint public openingICOTime = 1534291200000; // August 15, 2018 12AM UTC GMT
    uint public closingICOTime = 1537055999000; // Sat, 15 Sep 2018 23:59:59 GMT"

    // MERC token contract. 
    MercToken public mercToken;

    // ETH/USD 19 Jul 2018 12:45AM PST => Thu Jul 19 07:46:41 2018 UTC =>  FROM CMC 
    uint public usdPerKEther = 477720; // $USD per 1,000 Ether
    uint public constant USD_CENT_PER_MERC = 17;
    uint public constant MIN_CONTRIBUTION = 0.01 ether;

    // maximum amount of funds to be raised in weis
    uint256 public maxEtherCap; // 73,265 ether

    // various rates Temporary
    uint public tierOneRate = 1910880; // At $0.25 per token in USD 
    uint public tierTwoRate = 1308821; // At $0.365 per token in USD
    uint public preSaleRate = 1145612; // At $0.417 per token in USD
    uint public ICORate = 976932; // AT $0.489 per token in USD

    // Stage of Sale

    enum CrowdsaleStage { TierOne, TierTwo, PreSale, ICO }
    CrowdsaleStage public stage = CrowdsaleStage.TierOne; // By default it's pre-sale

    // TODO: PLEASE CHANGE!!!!
    address wallet = 0x12344563;
    address teamWallet = 0x123456789;

    // Deploys the ERC20 token. Automatically called when crowdsale contract is deployed.
    mercToken = new MercToken(); 

    /// @param _openingTime The start time of the tokenSale
    /// @param _closingTime The closing time of the crowdsale
    /// @param _rate
    /// @param _wallet is the address for the contract
    /// @param _token is the token 
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

    // Change Crowdsale Stage. Available Options: TierOne, TierTwo, preSale, ICO
    function setCrowdsaleStage(uint value) public onlyOwner {
      
      CrowdsaleStage _stage;

      if (uint(CrowdsaleStage.TierOne) == value) {
        _stage = CrowdsaleStage.TierOne;
      }
      if (uint(CrowdsaleStage.TierTwo) == value) {
        _stage = CrowdsaleStage.TierTwo;
      }
      if (uint(CrowdsaleStage.PreSale) == value) {
        _stage = CrowdsaleStage.PreSale;
      }
      if (uint(CrowdsaleStage.ICO) == value) {
        _stage = CrowdsaleStage.ICO;
      }

      stage = _stage;

      if (stage == CrowdsaleStage.TierOne) {
        setCurrentRate(tierOneRate);
      } else if (stage == CrowdsaleStage.TierTwo) {
        setCurrentRate(tierTwoRate);
      } else if (stage == CrowdsaleStage.PreSale) {
        setCurrentRate(preSaleRate);
      } else if (stage == CrowdsaleStage.ICO) {
        setCurrentRate(ICORate);
      }

    }

    // Change the current rate
    function setCurrentRate(uint256 _rate) private {
      rate = _rate;
    }

    // Checks whether maxEtherCap is reached
    function maxReached() public constant returns (bool) {
      return weiRaised == maxEtherCap;
    }

    // Once you gather more details from Matt, finish contract with finalise function for distro to others
    function finalization() internal {
      uint extraTokens = maxCrowdSaleTokens - weiRaised;
      // If it's past closingICOTime and we have extra tokens, burn the extra tokens
      if ((now > closingICOTime) && (extraTokens > 0)) {
        mercToken.burn(extraTokens);
      }
      // transfer tokens for team over to team
      token.transfer(teamTokens, teamWallet);
      // Will be called only after crowdsale ends
      withdrawTokens();
    }


}
