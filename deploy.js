import { ethers } from "hardhat";

async function main() {
  const DelayedExecutor = await ethers.getContractFactory("DelayedExecutor");
  const executor = await DelayedExecutor.deploy();
  await executor.deployed();
  console.log("DelayedExecutor deployed to:", executor.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
