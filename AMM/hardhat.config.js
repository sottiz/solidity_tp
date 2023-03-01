require("@nomiclabs/hardhat-ethers");
require("@openzeppelin/hardhat-upgrades");
require("@nomiclabs/hardhat-etherscan");

require('dotenv').config();
module.exports = {
  solidity: "0.8.10",
  networks: {
    fuji: {
      url: 'https://api.avax-test.network/ext/bc/C/rpc',
      gasPrice: 40000000000,
      chainId: 43113,
      accounts: [process.env.FUJI_ACCOUNT]
    },
    goerli: {
      url: process.env.GOERLI_URL_2,
      gasPrice: 40000000000,
      chainId: 5,
      accounts: [process.env.GOERLI_ACCOUNT]
    }
  },
  // ethernal
  ethernal: {
    email: process.env.ETHERNAL_EMAIL,
    password: process.env.ETHERNAL_PASSWORD
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};