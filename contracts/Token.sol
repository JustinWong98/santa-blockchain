// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// import base ERC-721 functionality
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// increment IDs when minting
import "@openzeppelin/contracts/utils/Counters.sol";
contract SantaToken is ERC721URIStorage{
    // using SafeMath for uint256;
    using Counters for Counters.Counter;
    uint256 public tokenPrice = 200000000000000;
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
        // global storage of contractor address, won't be reset
        address contractor;
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
        // approve(custodian, newItemId);

        NFTForSale memory token = NFTForSale(
            newItemId,
            price,
            false,
            false,
            msg.sender,
            msg.sender,
            msg.sender,
            msg.sender,
            _name,
            _description,
            _tokenURI
        );
        _listed.push(token);
        _tokenIds.increment();
    }

    // display price of NFT
    function displayPrice(uint256 _itemId) public view returns (uint256) {
        NFTForSale storage nftOnSale = _listed[_itemId];
        return nftOnSale.price;
    }

    // display price of NFT
    function displayContractor(uint256 _itemId) internal view returns (address) {
        NFTForSale storage nftOnSale = _listed[_itemId];
        return nftOnSale.contractor;
    }

    // called by wishlist - custodian account
    // ERC721 version
    // function transferNFT(
    //     // address _currentOwner,
    //     address _newOwner,
    //     uint256 _itemId
    // ) external {
    //     // use _currentOwner?
    //     transferFrom(_listed[_itemId].owner, _newOwner, _listed[_itemId].id);
    // }

    // non ERC721 version
    function transferNFT(
        address _newOwner,
        uint256 _itemId
    ) external {
        // use _currentOwner?
        _listed[_itemId].owner = _newOwner;
        _listed[_itemId].gifter = msg.sender;
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

    // To remove or refactor
    // function getWishCreated() external view returns (NFTForSale[] memory) {
    //     NFTForSale[] memory wishesCreated = new NFTForSale[](createdWishCounter);
    //     // uint default value is 0
    //     uint tempCount;
    //     for (uint i = 0; i < _listed.length; i++) {
    //         if (_listed[i].wishCreated == true) {
    //             wishesCreated[tempCount] = _listed[i];
    //             tempCount++;
    //         }
    //     }
    //     return wishesCreated;
    // }

    // To remove or refactor
    // function getWishUncreated() external view returns (NFTForSale[] memory) {
    //     uint uncreatedWishLength = _listed.length - createdWishCounter;
    //     NFTForSale[] memory wishesUncreated = new NFTForSale[](uncreatedWishLength);
    //     // uint default value is 0
    //     uint tempCount;
    //     for (uint i = 0; i < _listed.length; i++) {
    //         if (_listed[i].wishCreated != true) {
    //             wishesUncreated[tempCount] = _listed[i];
    //             tempCount++;
    //         }
    //     }
    //     return wishesUncreated;
    // }
}
