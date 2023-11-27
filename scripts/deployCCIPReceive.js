const hre = require("hardhat");
require('dotenv').config();

async function main() {
    const [deployer] = await ethers.getSigners();

    const CCIP = await ethers.getContractFactory("CCIPReceive");
    let optAddr = "0xac06e453682623Dd59D82571e7BF12aBC278C8D0"
    const ccipInstance = await CCIP.deploy(optAddr);
    let deployAddr2 = await ccipInstance.getAddress()
    console.log("CCIPReceive contract deployed to:", deployAddr2);
    await new Promise(r => setTimeout(r, 10000));
    await hre.run("verify:verify", {
        address: deployAddr2,
        constructorArguments: [
            "0xac06e453682623Dd59D82571e7BF12aBC278C8D0"
        ]
    })
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
