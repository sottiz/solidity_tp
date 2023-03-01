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

  const MyToken = await hre.ethers.getContractFactory("MyToken");
  const myToken = await MyToken.deploy();
  await myToken.deployed();
  
  console.log("MyToken contract deployed to:", myToken.address);

  const AMM = await hre.ethers.getContractFactory("AMM");
  const amm = await AMM.deploy(myToken.address);
  await amm.deployed();

  console.log("AMM contract deployed to:", amm.address);

  await hre.ethernal.push({
    name: 'MyToken',
    address: myToken.address
  });



  await hre.ethernal.push({
    name: 'AMM',
    address: amm.address
  });


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
}).finally(() => {
  process.exit();
});
