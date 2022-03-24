
const hre = require("hardhat");

async function main() {
  
  const Suid = await hre.ethers.getContractFactory("SuidToken");
  const suid = await Suid.deploy(1000);

  await suid.deployed();

  console.log("SuidToken deployed to:", suid.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
