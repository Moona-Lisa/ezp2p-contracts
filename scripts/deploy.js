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

  // add some tokens to the contract
  await new Promise(r => setTimeout(r, 5000));
  await optionsInstance.addToken("Link", "0x326c977e6efc84e512bb9c30f76e30c160ed06fb", true, "LINK", 18);
  await new Promise(r => setTimeout(r, 5000));
  await optionsInstance.addToken("Usdc", "0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747", true, "USDC", 18);

  console.log("Token added successfully.");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
