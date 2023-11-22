require("@nomicfoundation/hardhat-toolbox");
require("hardhat-preprocessor");
const fs = require("fs");
require('dotenv').config();

const MUMBAI_RPC_URL = process.env.MUMBAI_RPC_URL
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY
const PRIVATE_KEY = process.env.PRIVATE_KEY

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  preprocess: {
    eachLine: (hre) => ({
      transform: (line) => {
        if (line.match(/^\s*import /i)) {
          for (const [from, to] of getRemappings()) {
            if (line.includes(from)) {
              line = line.replace(from, to);
              break;
            }
          }
        }
        return line;
      },
    }),
  },
  paths: {
    sources: "./src",
    cache: "./cache_hardhat",
  },
  networks: {
    // mumbai: {
    //   url: "https://rpc-mumbai.maticvigil.com",
    //   accounts:
    //     [PRIVATE_KEY],
    // },
    fuji: {
      url: "https://api.avax-test.network/ext/bc/C/rpc",
      accounts:
        [PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
    // customChains: [
    //   {
    //     network: 'mumbai',
    //     chainId: 80001,
    //     urls: {
    //       apiURL: MUMBAI_RPC_URL,
    //       browserURL: "https://mumbai.polygonscan.com/",
    //     },
    //   },
    //   {
    //     network: 'fuji',
    //     chainId: 43113,
    //     urls: {
    //       apiURL: "https://api.avax-test.network/ext/bc/C/rpc",
    //       browserURL: "https://cchain.explorer.avax-test.network/",
    //     },
    //   },
    // ]
  },
};

function getRemappings() {
  return fs
    .readFileSync("remappings.txt", "utf8")
    .split("\n")
    .filter(Boolean) // remove empty lines
    .map((line) => line.trim().split("="));
}