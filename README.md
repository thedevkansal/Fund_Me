# 💰 Foundry FundMe 

A decentralized funding contract deployed on the **Sepolia Testnet**, built using [Foundry](https://book.getfoundry.sh/) and powered by [Chainlink](https://chain.link/) price feeds.

> 💼 Live Contract: [0xa51c30C4306622FA821927398B467151529F2E4B](https://sepolia.etherscan.io/address/0xa51c30C4306622FA821927398B467151529F2E4B)

---

## 💡 Features

- Accepts ETH donations, priced in **USD** using a Chainlink ETH/USD aggregator.
- Enforces a **minimum USD threshold** per contribution.
- Allows **only the contract owner** to withdraw funds.
- Tracks **funders and their contributions** for accountability.

---

## 🔧 Stack

- **Solidity** (`^0.8.18`)
- **Foundry** (Forge, Cast, Anvil)
- **Chainlink Price Feeds**
- **Sepolia Testnet**
- **Etherscan Verification**

---

## 🚀 Getting Started

### 🛠 Requirements

- [Foundry](https://getfoundry.sh/)
  - Confirm install with: `forge --version`
- [Git](https://git-scm.com/)
  - Confirm install with: `git --version`
- [Node RPC URL](https://www.alchemy.com/)
- [Sepolia ETH](https://faucets.chain.link/)
- [Metamask Wallet](https://metamask.io/)
- [Etherscan API Key](https://etherscan.io/)

---

## ⚡️ Quickstart

```bash
git clone <your-repo-url>
cd fund_me
forge install
cp .env.example .env
# Add your SEPOLIA_RPC_URL, PRIVATE_KEY, and ETHERSCAN_API_KEY to .env
source .env
forge build
```

---

## 🧪 Testing

### Run all tests

```bash
forge test
```

### Run specific test

```bash
forge test --match-test testFunctionName
```

### Test with Sepolia Fork

```bash
forge test --fork-url $SEPOLIA_RPC_URL
```

---

## 📤 Deployment

### Local (Anvil)

```bash
anvil
forge script script/DeployFundMe.s.sol \
  --rpc-url http://127.0.0.1:8545 \
  --private-key <ANVIL_PRIVATE_KEY> \
  --broadcast
```

### Sepolia

```bash
forge script script/DeployFundMe.s.sol \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --verify \
  --etherscan-api-key $ETHERSCAN_API_KEY
```

---

## 🔁 Interactions

### Fund the Contract

```bash
forge script script/Interactions.s.sol:FundFundMe \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast
```

### Withdraw Funds

```bash
forge script script/Interactions.s.sol:WithdrawFundMe \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast
```

### Using cast

```bash
cast send <FUNDME_CONTRACT_ADDRESS> "fund()" \
  --value 0.1ether \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY
```

---

## 📄 Contract Verification

After deployment:

```bash
forge verify-contract \
  --chain-id 11155111 \
  --watch \
  --compiler-version v0.8.30+commit.0b28295f \
  <CONTRACT_ADDRESS> \
  src/FundMe.sol:FundMe \
  --constructor-args <ENCODED_ARGS> \
  --etherscan-api-key $ETHERSCAN_API_KEY
```

> Tip: Use `cast abi-encode` to get constructor args.

---

## ⛽ Gas Reporting

```bash
forge snapshot
cat .gas-snapshot
```

---

## 🧼 Code Formatting

```bash
forge fmt
```

---

## ✅ Status

- [x] Local + Sepolia Deployment
- [x] Fund + Withdraw Functional
- [x] Etherscan Verified Contract
- [x] Chainlink Price Feeds Integrated
- [ ] Frontend UI (Planned)
- [ ] zkSync Integration (Planned)

---

## 🙌 Credits

- Inspired by: [Cyfrin Solidity Course](https://updraft.cyfrin.io/)
- Maintainer: [Dev Kansal](https://github.com/thedevkansal)

---

## 🔗 Links

- 🧠 [Etherscan Contract (Sepolia)](https://sepolia.etherscan.io/address/0xa51c30C4306622FA821927398B467151529F2E4B)
- 📚 [Chainlink Docs](https://docs.chain.link/)
- 🛠 [Foundry Book](https://book.getfoundry.sh/)
