# wallet_core

### basic usage example

* Initiate the core package with rpc url and approval callback.
* Set credentials using private key.
* Get address and balance.
* Transfer native token to another address.

```
import 'dart:async';
import 'package:wallet_core/wallet_core.dart';

final rpc = 'https://rpc.fusenet.io';
final networkId = 122;
final pkey = '...';

Future<bool> approvalCallback() async {
  return true;
}

void main() async {
  Web3 web3 = Web3(rpc, networkId, approvalCallback);
  
  await web3.setCredentials(pkey);

  EthereumAddress address = await web3.getAddress();
  EtherAmount balance = await web3.getBalance();
  print('balance of $address is ${balance.getInWei} wei (${balance.getValueInUnit(EtherUnit.ether)} ether)');

  String txHash = await web3.transferNative('0xB8Ce4A040E8aA33bBe2dE62E92851b7D7aFd52De', 100000000000000000);
  print('txHash: $txHash done');
}
```