# Fuse Wallet Core

Fuse wallet core library for Ethereum based networks, developed in Dart, can be used in Flutter framework.

## What's in here

* Web3
  * Using [`web3dart`](https://pub.dev/packages/web3dart) library in a simplified way
  * Initialized with any Ethereum based network (and custom network id)
  * BIP 39 mnemonic - generate, extract private key from
  * Native - get balance, send, sign off-chain transactions to transfer using relay
  * [ERC20 based tokens](https://eips.ethereum.org/EIPS/eip-20) - get balance, send, sign off-chain transactions to transfer using relay
  * Contracts - read/write
* API
  * Interact with [Fuse API](https://github.com/fuseio/fuse-studio/blob/master/server/docs/api-v2.md)
* GraphQL
  * Interact with [The Graph](https://thegraph.com/) for easier blockchain data reads

## Install

See [pub.dev](https://pub.dev/packages/wallet_core#-installing-tab-)

## Usage

See [`example`](https://github.com/fuseio/wallet_core/tree/master/example) folder

## License

Fuse Wallet Core is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
