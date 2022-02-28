// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

// import for logging/debugging
import "hardhat/console.sol";
// import some OpenZeppelin Contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// import for string util functions
import "@openzeppelin/contracts/utils/Strings.sol";
// import base64 decode/encode library
import { Base64 } from "base64-sol/base64.sol";


// Inherit from the imported contract to access contract methods
contract MyEpicNFT is ERC721URIStorage {
    // Magic give to us by OpenZeppelin is to help us keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Here's a template of the SVG code our mint will use. All we need to do is replace
    // the word that's displayed for each unique mint
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // Create three arrays, each with their own theme of random words
    string[] firstWords = ["England", "Germany", "France", "Austria", "Russia", "Sweden"];
    string[] secondWords = ["Plate", "Brigandine", "Mail", "Lamellar", "Scale", "Gambeson"];
    string[] thirdWords = ["Halberd", "Spear", "Mace", "Longsword", "Bow", "Dagger"];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    // We need to pass the name of our NFTs token and its symbol
    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Woah!");
    }

    // Create a function to randomly pick a word from each array
    function pickRandomFirstWord(uint tokenId) public view returns (string memory) {
        uint rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));

        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint tokenId) public view returns (string memory) {
        uint rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));

        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint tokenId) public view returns (string memory) {
        uint rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));

        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint) {
        return uint(keccak256(abi.encodePacked(input)));
    }

    // A function our user will hit to get their NFT
    function makeAnEpicNFT() public {
        // Get the current tokenId, this starts at 0
        uint newItemId = _tokenIds.current();

        // randomly grab one word for each of the three arrays
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        // concatenate all together and add </text> and </svg> tags
        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));

        // Get all the JSON metadata in place and base64 encode it
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 to encode our svg
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )

                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(
            string(
                abi.encodePacked("https://nftpreview.0xdev.codes/?code=",finalTokenUri)
            )
        );
        console.log("\n--------------------");

        // Actually mint the NFT ot the sender using msg.sender
        _safeMint(msg.sender, newItemId);

        // Set the NFT data
        _setTokenURI(newItemId, finalTokenUri);

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
