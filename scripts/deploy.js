const hre = require("hardhat");

async function main() {
  const Lock = await hre.ethers.getContractFactory("Lock");
  const lock = await Lock.deploy(Date.now() + 60 * 60 * 24 * 1000, { value: hre.ethers.parseEther("1") });
  await lock.waitForDeployment();
  console.log(`Lock deployed to: ${await lock.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
