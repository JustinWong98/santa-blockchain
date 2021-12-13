// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// import base ERC-721 functionality
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// increment IDs when minting
import "@openzeppelin/contracts/utils/Counters.sol";

contract SantaToken is ERC721URIStorage {
    // using SafeMath for uint256;
    using Counters for Counters.Counter;

    uint256 public tokenPrice = 200000000000000;
    address custodian;
    Counters.Counter public _tokenIds;
    NFTForSale[] public _listed;
    struct NFTForSale {
        uint256 id;
        uint256 price;
        bool isSold;
        bool wishCreated;
        address wisher;
        // may not need this since we have it in wishlist already as a mapping
        address owner;
        // gifter should just be one of our accounts until it is actually gifted
        address gifter;
        string name;
        string description;
        string imgURL;
    }

    mapping(uint => NFTForSale) filterByWishCreated;
    uint createdWishCounter;

    constructor() ERC721("SantaToken", "SNTA") {
        // _setBaseURI(
        //     "https://gateway.pinata.cloud/ipfs/QmNhz1N3jYmWAArDVwEPorcjJqaEQzxj9HMM2vx9bXuGFn/"
        // );
        // custodian should now equal to deployed address, how to get it?
        mintNFT(
            "https://gateway.pinata.cloud/ipfs/QmNhz1N3jYmWAArDVwEPorcjJqaEQzxj9HMM2vx9bXuGFn/Screenshot_100.png",
            tokenPrice,
            "CXGod",
            "The bad boy professional artist/photoshopper - he is a nocturnal creature that only comes alive at night."
        );
        mintNFT(
            "https://gateway.pinata.cloud/ipfs/QmNhz1N3jYmWAArDVwEPorcjJqaEQzxj9HMM2vx9bXuGFn/Screenshot_96.png",
            tokenPrice,
            "Akira",
            "Akira the unfortunate teacher - cursed with a weird rebellious batch for his last batch of bootcamp students."
        );
        mintNFT(
            "https://gateway.pinata.cloud/ipfs/QmNhz1N3jYmWAArDVwEPorcjJqaEQzxj9HMM2vx9bXuGFn/Screenshot_99.png",
            tokenPrice,
            "Shing Nan",
            "CXGod's true arch nemesis - the champion of both shit stirring and libraries."
        );
        mintNFT(
            "https://gateway.pinata.cloud/ipfs/QmNhz1N3jYmWAArDVwEPorcjJqaEQzxj9HMM2vx9bXuGFn/Screenshot_97.png",
            tokenPrice,
            "JWong",
            "His lungs are probably collapsed from using the V for so long."
        );
        mintNFT(
            "https://gateway.pinata.cloud/ipfs/QmNhz1N3jYmWAArDVwEPorcjJqaEQzxj9HMM2vx9bXuGFn/Screenshot_98.png",
            tokenPrice,
            "Jia En the Polar Bear",
            "Her back hurts from carrying projects."
        );
    }

    // custodian is our account
    function mintNFT(
        string memory _tokenURI,
        uint256 price,
        string memory _name,
        string memory _description
    ) public {
        uint256 newItemId = _tokenIds.current();

        // in case we want them to be able to mint their own nfts as a stretch goal
        // for now, it could just be whoever our creator address/custodian is
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        // custodian can transfer
        approve(custodian, newItemId);

        NFTForSale memory token = NFTForSale(
            newItemId,
            price,
            false,
            false,
            custodian,
            custodian,
            custodian,
            _name,
            _description,
            _tokenURI
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

    function getAllListed() external view returns (NFTForSale[] memory) {
        return _listed;
    }

    function getWishCreated() external view returns (NFTForSale[] memory result) {
        NFTForSale[] memory tempResult = new NFTForSale[](createdWishCounter);
        uint tempCount;
        for (uint i = 0; i < createdWishCounter; i++) {
            if (_listed[i].wishCreated == true) {
                result[tempCount] = _listed[i];
                tempCount++;
            }
        }
        result = new NFTForSale[](tempCount);
        for (uint j = 0; j <tempCount; j++) {
            result[j] = tempResult[j];
        }
        return result;
    }
}
