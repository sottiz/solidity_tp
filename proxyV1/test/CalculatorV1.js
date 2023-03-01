// test/1.Age.test.ts
const { expect } = require("chai");
const { ethers } = require("hardhat");
const { Contract, BigNumber } = require("ethers");

describe("CalculatorV1 (proxy)", function () {
  let val;

  beforeEach(async function () {
    const CalculatorV1 = await ethers.getContractFactory("CalculatorV1");

    val = await upgrades.deployProxy(CalculatorV1, [10], { initializer: "initialize" });
  });

  it("should retrieve value previously stored", async function () {
    console.log("Value is", parseInt(await val.getVal()));
    expect(parseInt(await val.getVal())).to.equal(10);

    console.log("Value is", parseInt(await val.add(100, 50)));
    expect(parseInt(await val.add(100, 50))).to.equal(150);
  });
});