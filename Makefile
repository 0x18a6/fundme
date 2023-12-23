-include .env

build:
	forge build

deploy-sepolia:
	forge script script/FundMe.s.sol:DeployFundMe --fork-url $(SEPOLIA_URL) --private-key $(PRIVATE_KEY) -vvvv

fund-anvil:
	forge script script/FundMe.s.sol --fork-url $(ANVIL_URL) --private-key $(ANVIL_KEY) -vvvv
	forge script script/Interactions.s.sol:FundFundMe --fork-url $(ANVIL_URL) --private-key $(ANVIL_KEY) --broadcast

fund-sepolia:
	forge script script/FundMe.s.sol --fork-url $(SEPOLIA_URL) --private-key $(PRIVATE_KEY) -vvvv
	forge script script/Interactions.s.sol:FundFundMe --fork-url $(SEPOLIA_URL) --private-key $(SEPOLIA_KEY) --broadcast
