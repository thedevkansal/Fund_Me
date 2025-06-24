//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    //fetch real time ETH/USD price from chainlink
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        (, int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price * 1e10); // price has 8 decimals, convert to 18
    }

    //To convert eth amount into USD
    function getConversionRate(uint256 ethamount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethpriceinusd = (ethPrice * ethamount) / 1e18;
        return ethpriceinusd;
    }
}
