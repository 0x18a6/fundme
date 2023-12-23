-include .env

build:
	forge build

deploy-sepolia:
	forge script script/FundMe.s.sol:DeployFundMe --fork-url $(SEPOLIA_URL) --private-key $(PRIVATE_KEY) -vvvv