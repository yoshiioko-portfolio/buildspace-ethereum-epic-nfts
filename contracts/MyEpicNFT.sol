// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "hardhat/console.sol";
// import some OpenZeppelin Contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// Inherit from the imported contract to access contract methods
contract MyEpicNFT is ERC721URIStorage {
    // Magic give to us by OpenZeppelin is to help us keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // We need to pass the name of our NFTs token and its symbol
    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Woah!");
    }

    // A function our user will hit to get their NFT
    function makeAnEpicNFT() public {
        // Get the current tokenId, this starts at 0
        uint newItemId = _tokenIds.current();

        // Actually mint the NFT ot the sender using msg.sender
        _safeMint(msg.sender, newItemId);

        // Set the NFT data
        _setTokenURI(newItemId, "https://jsonkeeper.com/b/KDTV");
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
    }
}
