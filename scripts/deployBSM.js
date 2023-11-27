const hre = require("hardhat");
require('dotenv').config();

async function main() {
    const [deployer] = await ethers.getSigners();

    const BSM = await ethers.getContractFactory("BSM");
    const bsmInstance = await BSM.deploy();
    let deployAddr = await bsmInstance.getAddress()
    console.log("BSM contract deployed to:", deployAddr);
    await new Promise(r => setTimeout(r, 10000));
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
