// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
require('dotenv').config();

async function main() {
  const [deployer] = await ethers.getSigners();

  const Options = await ethers.getContractFactory("Options");
  const optionsInstance = await Options.deploy();

  console.log("Options contract deployed to:", await optionsInstance.getAddress());

  let updaters = [process.env.UPDATER_ADDRESS1, process.env.UPDATER_ADDRESS2]

  //   string name;
  // address tokenAddress;
  // bool isAllowed;
  // string symbol;
  // uint256 decimals;


  // add some tokens to the contract
  await new Promise(r => setTimeout(r, 5000));
  await optionsInstance.setUpdater(updaters);
  await new Promise(r => setTimeout(r, 5000));
  await optionsInstance.addToken({
    name: "Link", tokenAddress: "0x326c977e6efc84e512bb9c30f76e30c160ed06fb", isAllowed: true, symbol: "LINK", decimals: 18,
    priceFeedAddress: "0xd9ffdb71ebe7496cc440152d43986aae0ab76665"
  });
  await new Promise(r => setTimeout(r, 5000));
  await optionsInstance.addToken({
    name: "Usdc", tokenAddress: "0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747", isAllowed: true, symbol: "USDC", decimals: 18,
    priceFeedAddress: "0xfe4a8cc5b5b2366c1b58bea3858e81843581b2f7"
  });

  console.log("Token added successfully.");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
