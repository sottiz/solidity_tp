require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: "0.8.0",
  networks: {
    /*fuji: {
      url: 'https://api.avax-test.network/ext/bc/C/rpc',
      gasPrice: 40000000000,
      chainId: 43113,
      accounts: [process.env.FUJI_ACCOUNT]
    },
    goerli: {
      url: process.env.GOERLI_URL,
      gasPrice: 40000000000,
      chainId: 5,
      accounts: [process.env.GOERLI_ACCOUNT]
    }*/
  }
};