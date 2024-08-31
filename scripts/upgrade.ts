const { ethers, upgrades } = require("hardhat");

async function main() {
    const contract = await ethers.getContractFactory("DLCNode");

    await upgrades.upgradeProxy(
        process.env.PROXY_CONTRACT,
        contract
    );
    console.log("contract upgraded");
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});