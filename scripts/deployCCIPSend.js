const hre = require("hardhat");
require('dotenv').config();

async function main() {
    const [deployer] = await ethers.getSigners();

    const CCIP = await ethers.getContractFactory("CCIPSend");

    const ccipInstance = await CCIP.deploy("0xD0daae2231E9CB96b94C8512223533293C3693Bf", "0x779877A7B0D9E8603169DdbD7836e478b4624789");
    let deployAddr2 = await ccipInstance.getAddress()
    console.log("CCIPSend contract deployed to:", deployAddr2);
    await new Promise(r => setTimeout(r, 15000));
    await hre.run("verify:verify", {
        address: deployAddr2,
        constructorArguments: [
            "0xD0daae2231E9CB96b94C8512223533293C3693Bf",
            "0x779877A7B0D9E8603169DdbD7836e478b4624789"
        ]
    })
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
