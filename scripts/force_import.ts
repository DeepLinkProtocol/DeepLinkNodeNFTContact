
// const { ethers, upgrades } = require("hardhat");


async function main() {
    const contractFactory = await ethers.getContractFactory("DLCNode");

    const r = await upgrades.forceImport(
        "0x2d8c44616e04B7F131bEee1e9b878765356F56f9",
        contractFactory
    )
    r.waitForDeployment()
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});