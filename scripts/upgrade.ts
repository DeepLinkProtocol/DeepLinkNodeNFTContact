const { ethers, upgrades } = require("hardhat");

async function main() {
    const contract = await ethers.getContractFactory("DLCNode");

    const r = await upgrades.upgradeProxy(
        process.env.PROXY_CONTRACT,
        contract,
        {txOverrides: {gasLimit: 3000000}}
    );
    r.waitForDeployment();
    console.log("contract upgraded");
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});