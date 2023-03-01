const { expect } = require("chai");
const { ethers } = require("hardhat");
const { Contract, BigNumber } = require("ethers");

describe("AMM contract", () => {
  let AMM;
  let amm;

  before(async () => {
    MyToken = await ethers.getContractFactory("MyToken");
    myToken = await MyToken.deploy();

    // Wait for the contract to be deployed
    await myToken.deployed();

    // Get the contract address
    console.log("MyToken deployed to:", myToken.address);

    AMM = await ethers.getContractFactory("AMM");
    amm = await AMM.deploy(myToken.address);

    // Wait for the contract to be deployed
    await amm.deployed();

    // Get the contract address
    console.log("AMM deployed to:", amm.address);

    // Approve the AMM contract to spend your tokens
    await myToken.approve(amm.address, 10000);

  });

  it("should add liquidity", async () => {
    // Call the addLiquidity function with some test parameters
    const result = await amm.addLiquidity(100, 100);

    // Check that the function returned the expected result
    expect(result).to.equal("expected result");
  });

  it("should remove liquidity", async () => {
    // Call the removeLiquidity function with some test parameters
    const result = await amm.removeLiquidity(token, tokenQuantity, ethQuantity);

    // Check that the function returned the expected result
    expect(result).to.equal("expected result");
  });

  // Add more test cases for the other functions of your contract
});
