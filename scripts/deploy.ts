import { ethers } from "hardhat";

async function main() {
  const formToken = await ethers.deployContract("FormToken");
  await formToken.waitForDeployment();

  console.log(`FormToken deployed to ${formToken.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
