const {expect,assert} = require("chai");
const {ethers} = require("hardhat");
const { waffle } = require("hardhat");
const{ impersonateFundErc20 } = require ("../utils/utilities");

 const{abi,} = require ("../artifacts/contracts/Interfaces/IERC20.sol/IERC20.json");

 const provider = waffle.provider;

 describe("flash swap contract", () =>{
    let FLASHSWAP, 
    BORROW_AMOUNT, 
    FUND_AMOUNT,
    InitiateFundHuman, 
    txArbitrage,
    getUsedUSD;

    const DECIMALS = 18;

    const BUSD_WAHLE ="0x47ac0Fb4F2D84898e4D9E7b4DaB3C24507a6D503";
    const BUSD = "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56";
    const CAKE = "0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82";
    const CROX = "0x2c094F5A7D1146BB93850f629501eB749f6Ed491";
    const USDT = "0x55d398326f99059fF775485246999027B3197955";

    const BASE_TOKEN_BUSD = BUSD;

    const tokenBase = new ethers.Contract(BASE_TOKEN_BUSD,abi,provider);

    beforeEach(async ()=>{
        // GET owner as the signer 
        console.log("ethers.utils:", ethers.utils);
        [owner] = await ethers.getSigners();

        // Ensure the whale has a balance
        const whale_balance = await provider.getBalance(BUSD_WAHLE);
        expect(whale_balance).not.equal("0");

    });

    it("general test", async () => {
        const whale_balance = await provider.getBalance(BUSD_WAHLE);
        console.log(ethers.utils.formatUnits(whale_balance.toString(),DECIMALS));

    });
 });
