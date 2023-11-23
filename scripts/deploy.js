const hre = require("hardhat");
require('dotenv').config();

async function main() {
  const [deployer] = await ethers.getSigners();

  const Options = await ethers.getContractFactory("Options");
  const optionsInstance = await Options.deploy();
  let deployAddr = await optionsInstance.getAddress()
  console.log("Options contract deployed to:", deployAddr);

  let updaters = [process.env.UPDATER_ADDRESS1, process.env.UPDATER_ADDRESS2]

  // add some tokens to the contract
  await new Promise(r => setTimeout(r, 5000));
  await optionsInstance.setUpdater(updaters);
  await new Promise(r => setTimeout(r, 5000));
  await optionsInstance.addToken({
    name: "chainlink", tokenAddress: "0x3A38c4d0444b5fFcc5323b2e86A21aBaaf5FbF26", isAllowed: true, symbol: "LINK", decimals: 18,
    priceFeedAddress: "0x34C4c526902d88a3Aa98DB8a9b802603EB1E3470", isStable: false
  });
  await new Promise(r => setTimeout(r, 5000));
  await optionsInstance.addToken({
    name: "usdc", tokenAddress: "0xCaC7Ffa82c0f43EBB0FC11FCd32123EcA46626cf", isAllowed: true, symbol: "USDC", decimals: 6,
    priceFeedAddress: "0x7898AcCC83587C3C55116c5230C17a6Cd9C71bad", isStable: true
  });
  await new Promise(r => setTimeout(r, 5000));
  await optionsInstance.addToken({
    name: "bitcoin", tokenAddress: "0x0EFD8Ad2231c0B9C4d63F892E0a0a59a626Ce88d", isAllowed: true, symbol: "WBTC", decimals: 8,
    priceFeedAddress: "0x31CF013A08c6Ac228C94551d535d5BAfE19c602a", isStable: false
  });
  await new Promise(r => setTimeout(r, 5000));
  await optionsInstance.addToken({
    name: "ethereum", tokenAddress: "0xf97b6C636167B529B6f1D729Bd9bC0e2Bd491848", isAllowed: true, symbol: "WETH", decimals: 18,
    priceFeedAddress: "0x86d67c3D38D2bCeE722E601025C25a575021c6EA", isStable: false
  });

  await hre.run("verify:verify", {
    address: deployAddr,
  })
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
