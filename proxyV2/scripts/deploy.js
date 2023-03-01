// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const ethernal = require('hardhat-ethernal');

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const PriceConsumerV3 = await hre.ethers.getContractFactory("PriceConsumerV3");
  // const MyUSDT = await hre.ethers.getContractFactory("MyUSDT");

  const priceConsumerV3 = await PriceConsumerV3.deploy();
  // const myUSDT = await MyUSDT.deploy();

  await priceConsumerV3.deployed();
  // await myUSDT.deployed();

  await hre.ethernal.push({
    name: 'Pulse',
    address: pulse.address,
    contract: 'contracts/Pulse.sol:Pulse',
    args: [],
  });

  // await hre.ethernal.push({
  //   name: 'MyUSDT',
  //   address: myUSDT.address,
  //   contract: 'contracts/MyUSDT.sol:MyUSDT',
  //   args: [],
  // });

  
  console.log("PriceConsumerV3 deployed to:", priceConsumerV3.address);
  // console.log("MyUSDT deployed to:", myUSDT.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
