# FundMe **( ͡° ͜ʖ ͡°)**

![happy merchant](https://upload.wikimedia.org/wikipedia/en/1/1d/The_Happy_Merchant.jpg)

the contract allows users to fund it with Ether and only the Owner to withdraw the funds.

### Usage

1. clone this repo
2. populate .env file
3. useful commands:

   - `make help`: help, duh.

   - `make build`: builds the project.

   - `make anvil`: creates a local testnet node for deploying and testing sc.

   - `make deploy ARGS="--network $NETWORK_ARGS"`: deploys `FundMe` contract. ($NETWORK_ARGS is either anvil or sepolia)

   - `make fund ARGS="--network $NETWORK_ARGS"`: funds the `FundMe` contract.

   - `make withdraw ARGS="--network $NETWORK_ARGS"`: withdraw funds from `FundMe` contract.

### Licsense

project from Cyfrin Updraft: [Foundry Fundamentals](https://updraft.cyfrin.io/courses/foundry)
