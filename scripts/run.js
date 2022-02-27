// run cmd: npx hardhat run scripts/run.js

const { ethers } = require("hardhat");

const main = async () => {
  const nftContractFactory = await ethers.getContractFactory("MyEpicNFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // call the mint function
  let txn = await nftContract.makeAnEpicNFT();
  // Wait for it to be minted
  await txn.wait();

  // Mint another NFT for fun
  txt = await nftContract.makeAnEpicNFT();
  // Wait for it to be minted
  await txn.wait();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
