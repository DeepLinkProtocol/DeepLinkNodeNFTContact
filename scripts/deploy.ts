
import dotenv from 'dotenv';
const {ethers} = require("hardhat");
dotenv.config();

async function main() {
    console.log("Deploying DLCNode...");
    console.log("owner: ", process.env.OWNER);

    const contractFactory = await ethers.getContractFactory("DLCNode");
    const upgrade = await upgrades.deployProxy(
        contractFactory,
        [process.env.OWNER],
        { initializer: 'initialize' }
    );
    console.log("deployed to:", upgrade.target);
}

main()