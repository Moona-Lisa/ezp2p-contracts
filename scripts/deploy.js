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

  // add some tokens to the contract
  await new Promise(r => setTimeout(r, 5000));
  await optionsInstance.setUpdater(updaters);
  await new Promise(r => setTimeout(r, 5000));
  await optionsInstance.addToken({
    name: "chainlink", tokenAddress: "0x9DFf9E93B1e513379cf820504D642c6891d8F7CC", isAllowed: true, symbol: "LINK", decimals: 18,
    priceFeedAddress: "0x1C2252aeeD50e0c9B64bDfF2735Ee3C932F5C408", isStable: false
  });
  await new Promise(r => setTimeout(r, 5000));
  await optionsInstance.addToken({
    name: "usdc", tokenAddress: "0x52D800ca262522580CeBAD275395ca6e7598C014", isAllowed: true, symbol: "USDC", decimals: 18,
    priceFeedAddress: "0x572dDec9087154dC5dfBB1546Bb62713147e0Ab0", isStable: true
  });
  await new Promise(r => setTimeout(r, 5000));
  await optionsInstance.addToken({
    name: "bitcoin", tokenAddress: "0x2Fa2e7a6dEB7bb51B625336DBe1dA23511914a8A", isAllowed: true, symbol: "WBTC", decimals: 18,
    priceFeedAddress: "0x007A22900a3B98143368Bd5906f8E17e9867581b", isStable: false
  });
  await new Promise(r => setTimeout(r, 5000));
  await optionsInstance.addToken({
    name: "ethereum", tokenAddress: "0xc199807AF4fEDB02EE567Ed0FeB814A077de4802", isAllowed: true, symbol: "WETH", decimals: 18,
    priceFeedAddress: "0x0715A7794a1dc8e42615F059dD6e406A6594651A", isStable: false
  });

  console.log("Token added successfully.");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
