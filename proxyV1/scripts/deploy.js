// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const ethernal = require('hardhat-ethernal');
const { ethers, upgrades } = require("hardhat");

async function main() {
   const PriceConsumerV3 = await ethers.getContractFactory("PriceConsumerV3");
    console.log("Deploying PriceConsumerV3...");
    const priceConsumerV3 = await upgrades.deployProxy(PriceConsumerV3);
    await priceConsumerV3.deployed();

    console.log("PriceConsumerV3 deployed to:", priceConsumerV3.address);
    await hre.ethernal.push({
        name: 'PriceConsumerV3',
        address: priceConsumerV3.address
      });

}

// cli command: npx hardhat run scripts/deploy.js --network fuji

main();
