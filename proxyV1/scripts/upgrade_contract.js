const { ethers, upgrades } = require("hardhat");
//the address of the deployed proxy
const PROXY = "0x29A9356515d56b7343Ccc45542Bac28c538b3396";

async function main() {
    const PriceConsumerV3 = await ethers.getContractFactory("PriceConsumerV3");
    console.log("Upgrading PriceConsumerV3...");
    const priceConsumerV3 = await upgrades.upgradeProxy(PROXY, PriceConsumerV3);

    
    console.log("PriceConsumerV3 upgraded");
}

main();