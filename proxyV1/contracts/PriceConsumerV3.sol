// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract PriceConsumerV3 {
    AggregatorV3Interface internal priceFeed;
    uint public nextBlockstamp;
    
    address[] public users;
    mapping(address => Bet) public bets;
    uint public pool;

    // contract initializer
    function initialize() public {
        priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        nextBlockstamp = block.timestamp + 10;
    }

    struct Bet {
        address user;
        uint amount;
        uint prediction;
    }

    function getBlockTimestamp() public view returns (uint) {
        return block.timestamp;
    }
    
    function getLatestPrice() public view returns (int) {
        (
            ,
            /*uint80 roundID*/ int price /*uint startedAt*/ /*uint timeStamp*/ /*uint80 answeredInRound*/,
            ,
            ,

        ) = priceFeed.latestRoundData();
        return price;
    }

    function getPoolAmount() public view returns (uint) {
        return pool;
    }

    function placeABet(uint prediction) public payable returns (uint) {
        require(msg.value > 0, "You need to send some ether");
        Bet memory bet = Bet(msg.sender, msg.value, prediction);
        bets[msg.sender] = bet;
        users.push(msg.sender);
        pool += msg.value;

        return nextBlockstamp;
    }

    function getBet(address _user) public view returns (Bet memory) {
        return bets[_user];
    }

    function rewardUsers() public {
        require(block.timestamp > nextBlockstamp, "Too early");
        
        uint latestPrice = uint(getLatestPrice());
        address winner = users[0];
        
        for (uint i = 0; i < users.length; i++) {
            int diff = latestPrice > bets[users[i]].amount ? int(latestPrice - bets[users[i]].amount) : int(bets[users[i]].amount - latestPrice);
            int winnerDiff = latestPrice > bets[winner].amount ? int(latestPrice - bets[winner].amount) : int(bets[winner].amount - latestPrice);
            if (diff < winnerDiff) {
                winner = users[i];
            }
        }

        payable(winner).transfer(pool);

        pool = 0;
        nextBlockstamp = block.timestamp + 10;
        users = new address[](0);
    }
}
