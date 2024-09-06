compile:
	npx hardhat compile

deploy:
	npx hardhat run scripts/deploy.ts --network dbcTestnet

upgrade:
	DEBUG='@openzeppelin:*' npx hardhat run scripts/upgrade.ts --network dbcTestnet

verify:
	npx hardhat verify --network dbcTestnet  0x2d8c44616e04B7F131bEee1e9b878765356F56f9













