
import dotenv from 'dotenv';
import {bigint} from "hardhat/internal/core/params/argumentTypes";
const { ethers} = require("hardhat");
dotenv.config();

async function main() {
    const contractFactory = await ethers.getContractFactory("DLCNode");
    const upgrade = await upgrades.deployProxy(contractFactory , [process.env.OWNER], { initializer: 'initialize' });
    console.log("deployed to:", upgrade.target);
}

main();