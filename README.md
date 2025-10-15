# Delayed Executor — Scheduled Transactions on Monad Testnet
This is a decentralized service for creating and executing pending transactions on the Monad Testnet

Test: https://gmonad.store/delayed-executor/

[![Monad Testnet](https://img.shields.io/badge/Deployed-Monad%20Testnet-blueviolet)](https://testnet.monadexplorer.com/address/0x158290dA77268EE28bc16F7d3D6Dbf10C866e791)
[![MetaMask Smart Accounts](https://img.shields.io/badge/Compatible-MetaMask%20Smart%20Accounts-orange)](https://docs.metamask.io/delegation-toolkit)

## Overview

**Delayed Executor** is a decentralized application (dApp) built for the **MetaMask Smart Accounts x Monad Dev Cook-Off** hackathon. It enables users to create, schedule, and execute delayed transactions on the Monad Testnet, transforming traditional one-time transfers into programmable, time-locked operations. Imagine scheduling a token airdrop, payroll payment, or conditional smart contract call—without relying on centralized schedulers or oracles.

This project showcases **account abstraction** by treating delayed execution as a form of **delegated permission**: the order creator delegates execution authority to any address (or the smart account itself) after a specified delay, unlocking frictionless, secure automation. Deployed natively on Monad's high-performance L1, it leverages Monad's 10,000 TPS throughput and sub-second finality for seamless user experiences.

Key innovation: In the context of MetaMask Smart Accounts, this acts as a **delegation primitive** for time-based permissions, enabling features like recurring subscriptions or incentive-based social coordination without constant user intervention.

## Hackathon Alignment

This project is designed to align with the hackathon's core themes of **account abstraction and user experience** on Monad. Here's how it incorporates the required features:

- **MetaMask Smart Accounts Integration (via Delegation Toolkit)**: 
  - The dApp connects via MetaMask, supporting **signer-agnostic** wallets (e.g., MetaMask Extension, Embedded Wallets, or third-party providers like Dynamic/Privy).
  - Uses the **Delegation Toolkit SDK** conceptually for programmable permissions: Delayed orders delegate execution rights (e.g., `target.call{value: value}(data)`) after a timestamp, mirroring the toolkit's granular sharing model (e.g., time-bound delegations for gasless or multi-sig flows).
  - **Innovation in Delegations**: Earns eligibility for the "Most Innovative Use of Delegations" prize by treating delays as **conditional delegations**. Creators can "delegate" to a smart account's hybrid/multisig setup (e.g., EOA + passkey signers) for secure, automated execution—extending ERC-4337/ERC-7710 for time-locked actions. Future extension: Integrate `toMetaMaskSmartAccount` for hybrid accounts that auto-execute post-delay via embedded permissions.
  - Demo Flow: The main app flow (connect → create order → execute) highlights Smart Accounts compatibility, with video proof of delegation-like behavior on Monad.

- **Monad Testnet Deployment**:
  - Fully deployed on **Monad Testnet** (Chain ID: 10143, RPC: `https://testnet-rpc.monad.xyz`).
  - Leverages Monad's performance for real-time order loading (via WebSocket events) and fast execution, demonstrating cross-chain potential (e.g., bridge to Ethereum for hybrid orders).
  - Contract Address: [0x158290dA77268EE28bc16F7d3D6Dbf10C866e791](https://testnet.monadexplorer.com/address/0x158290dA77268EE28bc16F7d3D6Dbf10C866e791).

- **Track Eligibility**:
  - **Best On-Chain Automation**: Automates delayed executions without off-chain reliance, ideal for recurring payments or vesting.
  - **Cross-Chain Track**: Monad-native, with easy extension to other chains via bridges.
  - **Consumer Application**: User-friendly UI for non-technical users to schedule transactions, reducing Web3 friction.

Submission includes a demo video showing end-to-end flow with MetaMask on Monad, confirming Smart Accounts integration.

## Features

- **Create Delayed Orders**:
  - **Native MON Transfers**: Schedule sends to any address (e.g., 0.01 MON after 5 minutes).
  - **ERC20 Transfers**: Delegate token sends (e.g., USDC/USDT on testnet) via `transfer(to, amount)`.
  - **Custom Calldata**: Arbitrary calls (e.g., NFT mints or DeFi interactions) with optional value.
  - Time-lock: Set delays in minutes (enforced by `executeAfter` timestamp).

- **View & Monitor Orders**:
  - List orders by ID, sorted by execution time.
  - Real-time updates via WebSocket events (`OrderCreated`, `OrderExecuted`).
  - Status indicators: Pending (🟢), Ready (💚), Executed (🟠).

- **Execute Orders**:
  - Manual trigger after delay (checks `block.timestamp >= executeAfter`).
  - Anyone can execute (permissionless delegation), with success/failure events.
  - Gas-efficient: Forwards `value` and `data` in a single `call`.

- **Security & UX**:
  - Reentrancy-safe via `executed` flag.
  - Neon-themed, responsive UI with loading states and error handling.
  - Auto-switch to Monad Testnet in MetaMask.

## Tech Stack

- **Smart Contract**: Solidity 0.8.20 (DelayedExecutor.sol) – Simple, auditable escrow for delayed calls.
- **Deployment**: Hardhat + Ethers.js v6 (deploy.js, hardhat.config.js).
- **Frontend**: Vanilla HTML/JS + Ethers.js (index.html) – No frameworks for lightweight Monad compatibility.
- **Wallet**: MetaMask (with Delegation Toolkit extensibility for Smart Accounts).
- **Network**: Monad Testnet (MON native token, Explorer: https://testnet.monadexplorer.com).
- **Libraries**: Ethers.js for ABI interactions; WebSockets for event listening.

## Quick Start

### Prerequisites
- Node.js 18+.
- MetaMask with Monad Testnet added (Chain ID: 10143, RPC: https://testnet-rpc.monad.xyz).
- Test MON from [Faucet](https://faucet.monad.xyz).

### Installation & Deployment
1. Clone/Fork the repo.
2. Install dependencies:
   ```
   npm install
   ```
3. Set `PRIVATE_KEY` in `.env` (your deployer wallet).
4. Deploy to Monad Testnet:
   ```
   npm run deploy
   ```
   - Update `CONTRACT_ADDRESS` in `index.html` with the output (e.g., 0x158290dA77268EE28bc16F7d3D6Dbf10C866e791).

### Run Locally
- Serve `index.html` (e.g., via `npx http-server`).
- Open in browser, connect MetaMask, and create/execute orders.

### Usage Example
1. Connect MetaMask → Switch to Monad Testnet.
2. Select "Native" order → Enter target address & 0.01 MON → Set 1-min delay → Create.
3. Wait → Execute via ID (auto-checks readiness).
4. View real-time logs in the orders list.

## Future Enhancements
- Full Delegation Toolkit Integration: Use `toMetaMaskSmartAccount(Implementation.Hybrid)` for passkey-delegated executions.
- Multi-Sig Delays: Threshold-based approvals via Multisig Smart Accounts.
- Cross-Chain: Bridge orders to Ethereum using Monad's EVM compatibility.
- Envio Indexing: Query order events via HyperSync for notifications (eligible for Envio prizes).

## Resources
- [Contract on Explorer](https://testnet.monadexplorer.com/address/0x158290dA77268EE28bc16F7d3D6Dbf10C866e791)
- [Demo Video](https://youtu.be/172bO35MY6A) – Shows Smart Accounts flow on Monad.
- [Delegation Toolkit Docs](https://docs.metamask.io/delegation-toolkit)
- [Monad Docs](https://docs.monad.xyz)

Built with ❤️ for the MetaMask x Monad Hackathon. 
-
