compile:
	npx hardhat compile

deploy:
	npx hardhat run scripts/deploy.ts --network dbcTestnet

upgrade:
	DEBUG='@openzeppelin:*' npx hardhat run scripts/upgrade.ts --network dbcTestnet

verify:
	source .env && npx hardhat verify --network dbcTestnet  $PROXY_CONTRACT


deploy-bsc-testnet:
	npx hardhat run scripts/deploy.ts --network bscTestnet

upgrade-bsc-testnet:
	DEBUG='@openzeppelin:*' npx hardhat run scripts/upgrade.ts --network bscTestnet

verify-bsc-testnet:
	source .env && npx hardhat verify --network bscTestnet  $PROXY_CONTRACT











