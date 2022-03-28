const hre = require("hardhat");

const main = async () => {

  const [owner] = await hre.ethers.getSigners();
  const TreasuryContractFactory = await hre.ethers.getContractFactory("Treasury");
  const TreasuryContract = await TreasuryContractFactory.deploy(); 
  await TreasuryContract.deployed();

  console.log("TreasuryContract deployed to:", TreasuryContract.address);
  console.log("TreasuryContract owner address:", owner.address);
}


const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.error(error);
      process.exit(1);
    }
  };
  
  runMain();