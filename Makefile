-include .env

build:
	forge build

deploy-sepolia:
	forge script script/FundMe.s.sol:DeployFundMe --fork-url $(SEPOLIA_URL) --private-key $(PRIVATE_KEY) -vvvv

fund:
	forge script script/interactions.s.sol:FundFundMe --fork-url $(SEPOLIA_URL) --private-key $(PRIVATE_KEY)
	forge script script/FundMe.s.sol:FundMe.fund --fork-url $(SEPOLIA_URL) --private-key $(PRIVATE_KEY)