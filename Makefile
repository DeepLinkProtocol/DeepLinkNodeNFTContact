compile:
	npx hardhat compile

deploy:
	npx hardhat run scripts/deploy.ts --network dbcTestnet

upgrade:
	npx hardhat run scripts/upgrade.ts --network dbcTestnet

verify:
	npx hardhat verify --network dbcTestnet  0xb976c5aCD4328C614A558FE1F67f0119b6b09441







