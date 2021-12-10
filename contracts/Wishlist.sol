// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Token.sol";

contract Wishlist {
    // map to wish
    mapping(uint256 => address) public wishes;
    // map inapp currency
    mapping(address => uint256) public points;

    // list of NFTs

    // import Tokens
    SantaToken public token;

    // if user hasn't joined before
    function initUser(address _from) public {
        points[_from] = 0;
    }

    // create a wish
    function createWish(address _from, uint256 _itemId) public {
        wishes[_itemId] = _from;
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
    }

    // redeem incentve
    function redeem(address _from, uint256 _itemId) public {
        // may need to change 0 to how much the NFT costs
        require(points[_from] > 0);
        points[_from] -= 1;
        // incentive nft now points to _from
        token.transferNFT(_from, _itemId);
    }

    // view points
    function getPoints(address _from) public view returns (uint256) {
        return points[_from];
    }
}
