// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Wishlist {
    // map to wish
    mapping(uint256 => address) public wishes;
    // map inapp currency
    mapping(address => uint256) public points;

    // if user hasn't joined before
    function initUser(address _from) public {
        points[_from] = 0;
    }

    // create a wish
    function createWish(address _from, uint256 _itemId) public {
        wishes[_itemId] = _from;
    }

    // fulfill a wish
    function buyWish(address _from, uint256 _itemId) public {}

    // redeem incentve
    function redeem(address _from, uint256 _itemId) public {}
}
