import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  const formRewards = await ethers.deployContract("FormRewards");
  await formRewards.waitForDeployment();

  console.log("FormRewards deployed to:", await formRewards.getAddress());

  // Optional: Verify the reward amount
  const rewardAmount = await formRewards.rewardAmount();
  console.log(
    "Default reward amount:",
    ethers.formatEther(rewardAmount),
    "tokens"
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
