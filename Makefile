compile:
	npx hardhat compile

deploy:
	npx hardhat run scripts/deploy.ts --network dbcTestnet

upgrade:
	DEBUG='@openzeppelin:*' npx hardhat run scripts/upgrade.ts --network dbcTestnet

verify:
	npx hardhat verify --network dbcTestnet  0x71B0e69E6b15893944776cFd2026Fa32e395a333












