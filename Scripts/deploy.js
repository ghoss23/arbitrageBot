
const {ethers} = require("hardhat");



async function main(){
  const [deployer] = await ethers.getSigners()

  console.log("Deploying contract with the contract", deployer.address);

  console.log("Account balance:",(await deployer.getBalnce()).toString());

  const Token= await ethers.getContractFactory("pancakeFlashSwap");
  const token = Token.deploy()

  console.log("token address:",token.address())
}

main().then(()=> process.exit(0)).catch((error) => {
  console.error(error);
  process.exit(1);
});
