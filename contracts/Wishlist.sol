// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Token.sol";
import "./Incentive.sol";

contract Wishlist is SantaToken, Incentive {
    // map to wish
    // use the ids generated in our token
    mapping(uint256 => address) public wishes;
    // map inapp currency
    mapping(address => uint256) public points;

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
        uint256 price = displayPrice(_itemId);
        uint256 amountPaid = msg.value;
        require(amountPaid >= price);
        // smart contract owns all the NFTS (nft addresses point to smart contract address)
        // smart contract takes the money
        address payable smartContractor = payable(displayContractor(_itemId));
        smartContractor.transfer(amountPaid);
        // then smart contract releases the nft to the wishmaker
        // token.transferNFT(wishes[_itemId], _itemId);

        markAsSold(_itemId);
        // we need to store the buyers address which is tied to the NFT now
        setGifter(_itemId, _from);
        points[_from]++;
    }

    // redeem incentve
    function redeem(address _from, uint256 _itemId) public {
        // may need to change 0 to how much the NFT costs
        require(points[_from] > 0, "You do not have enough points!");
        points[_from]--;
        // incentive nft now points to _from
        transferIncentive(_from, _itemId);
        // do we need to change owner manually?
    }

    // view points
    function getPoints(address _from) public view returns (uint256) {
        return points[_from];
    }

    function getOwner(uint256 _itemId) public view returns (address) {
        return ownerOf(_itemId);
    }
}
