// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Token.sol";
import "./Incentive.sol";

contract Wishlist is SantaToken {
    // map to wish
    // use the ids generated in our token
    mapping(uint256 => address) public wishes;
    // map inapp currency
    mapping(address => uint256) public points;

    // import incentives
    Incentive public incentiveNFT;
    // import Tokens
    SantaToken public token;

    // if user hasn't joined before
    function initUser(address _from) public {
        require(points[_from] == 0);
        points[_from] = 1;
    }

    // create a wish
    function createWish(address _from, uint256 _itemId) public {
        require(wishes[_itemId] == address(0));
        wishes[_itemId] = _from;
        _listed[_itemId].wisher = _from;
        _listed[_itemId].wishCreated = true;
        filterByWishCreated[createdWishCounter] = _listed[_itemId];
        createdWishCounter++;
    }

    // fulfill a wish
    function buyWish(address _from, uint256 _itemId) public payable {
        uint256 price = token.displayPrice(_itemId);
        uint256 amountPaid = msg.value;
        require(amountPaid >= price);
        // smart contract owns all the NFTS (nft addresses point to smart contract address)
        // smart contract takes the money
        address payable currentOwner = payable(token.ownerOf(_itemId));
        currentOwner.transfer(amountPaid);
        // then smart contract releases the nft to the wishmaker
        // may be using currentOwner as opposed to just the custodian so that we can implement trading inbetween users after they are sold?
        token.transferNFT(wishes[_itemId], _itemId);
        token.markAsSold(_itemId);
        // we need to store the buyers address which is tied to the NFT now
        token.setGifter(_itemId, _from);
        points[_from] += 1;
    }

    // redeem incentve
    function redeem(address _from, uint256 _itemId) public {
        // may need to change 0 to how much the NFT costs
        require(points[_from] > 0);
        points[_from] -= 1;
        // incentive nft now points to _from
        incentiveNFT.transferIncentive(_from, _itemId);
        // do we need to change owner manually?
    }

    // view points
    function getPoints(address _from) public view returns (uint256) {
        return points[_from];
    }
}
