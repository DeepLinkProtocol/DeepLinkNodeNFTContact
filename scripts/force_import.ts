
// const { ethers, upgrades } = require("hardhat");


async function main() {
    const contractFactory = await ethers.getContractFactory("DLCNode");

    const r = await upgrades.forceImport(
        "0x2640d3a6EFa9615EAb72c508881f2B1513A47a14",
        contractFactory
    )
    r.waitForDeployment()
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});