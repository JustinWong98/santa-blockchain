// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// import base ERC-721 functionality
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// increment IDs when minting
import "@openzeppelin/contracts/utils/Counters.sol";

contract SantaToken is ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter public _tokenIds;
    NFTForSale[] public _listed;
    struct NFTForSale {
        uint256 id;
        uint256 price;
        bool isSold;
        // may not need this since we have it in wishlist already as a mapping
        address owner;
        // gifter should just be one of our accounts until it is actually gifted
        address gifter;
    }

    constructor() ERC721("SantaToken", "SNTA") {}

    // custodian is our account
    function mintNFT(
        string memory _tokenURI,
        uint256 price,
        address _custodian
    ) public {
        uint256 newItemId = _tokenIds.current();

        // in case we want them to be able to mint their own nfts as a stretch goal
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        // custodian can transfer
        approve(_custodian, newItemId);

        NFTForSale memory token = NFTForSale(
            newItemId,
            price,
            false,
            _custodian,
            _custodian
        );
        _listed.push(token);
        _tokenIds.increment();
    }

    // display price of NFT
    function displayPrice(uint256 _itemId) external view returns (uint256) {
        NFTForSale storage nftOnSale = _listed[_itemId];
        return nftOnSale.price;
    }

    // called by wishlist - custodian account
    function transferNFT(
        // address _currentOwner,
        address _newOwner,
        uint256 _itemId
    ) external {
        // use _currentOwner?
        transferFrom(_listed[_itemId].owner, _newOwner, _listed[_itemId].id);
    }

    function markAsSold(uint256 _itemId) public {
        NFTForSale storage nft = _listed[_itemId];
        nft.isSold = true;
    }

    function setGifter(uint256 _itemId, address _gifter) public {
        NFTForSale storage nft = _listed[_itemId];
        nft.gifter = _gifter;
    }
}
