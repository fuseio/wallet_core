import 'dart:convert';

class ABI {
  static String get(String name) {
    List<Map<String, Object>> abi;
    switch (name) {
      case "BasicToken":
        abi = [
          {
            "constant": true,
            "inputs": [],
            "name": "name",
            "outputs": [
              {"name": "", "type": "string"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "spender", "type": "address"},
              {"name": "value", "type": "uint256"}
            ],
            "name": "approve",
            "outputs": [
              {"name": "", "type": "bool"}
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "totalSupply",
            "outputs": [
              {"name": "", "type": "uint256"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "sender", "type": "address"},
              {"name": "recipient", "type": "address"},
              {"name": "amount", "type": "uint256"}
            ],
            "name": "transferFrom",
            "outputs": [
              {"name": "", "type": "bool"}
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "decimals",
            "outputs": [
              {"name": "", "type": "uint8"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "spender", "type": "address"},
              {"name": "addedValue", "type": "uint256"}
            ],
            "name": "increaseAllowance",
            "outputs": [
              {"name": "", "type": "bool"}
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "tokenURI",
            "outputs": [
              {"name": "", "type": "string"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {"name": "account", "type": "address"}
            ],
            "name": "balanceOf",
            "outputs": [
              {"name": "", "type": "uint256"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [],
            "name": "renounceOwnership",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "owner",
            "outputs": [
              {"name": "", "type": "address"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "isOwner",
            "outputs": [
              {"name": "", "type": "bool"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "symbol",
            "outputs": [
              {"name": "", "type": "string"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "spender", "type": "address"},
              {"name": "subtractedValue", "type": "uint256"}
            ],
            "name": "decreaseAllowance",
            "outputs": [
              {"name": "", "type": "bool"}
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "recipient", "type": "address"},
              {"name": "amount", "type": "uint256"}
            ],
            "name": "transfer",
            "outputs": [
              {"name": "", "type": "bool"}
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {"name": "owner", "type": "address"},
              {"name": "spender", "type": "address"}
            ],
            "name": "allowance",
            "outputs": [
              {"name": "", "type": "uint256"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "newOwner", "type": "address"}
            ],
            "name": "transferOwnership",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "inputs": [
              {"name": "name", "type": "string"},
              {"name": "symbol", "type": "string"},
              {"name": "initialSupply", "type": "uint256"},
              {"name": "tokenURI", "type": "string"}
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "constructor"
          },
          {
            "anonymous": false,
            "inputs": [
              {"indexed": false, "name": "tokenURI", "type": "string"}
            ],
            "name": "TokenURIChanged",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {"indexed": true, "name": "previousOwner", "type": "address"},
              {"indexed": true, "name": "newOwner", "type": "address"}
            ],
            "name": "OwnershipTransferred",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {"indexed": true, "name": "from", "type": "address"},
              {"indexed": true, "name": "to", "type": "address"},
              {"indexed": false, "name": "value", "type": "uint256"}
            ],
            "name": "Transfer",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {"indexed": true, "name": "owner", "type": "address"},
              {"indexed": true, "name": "spender", "type": "address"},
              {"indexed": false, "name": "value", "type": "uint256"}
            ],
            "name": "Approval",
            "type": "event"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "tokenURI", "type": "string"}
            ],
            "name": "setTokenURI",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          }
        ];
        break;
      case "Community":
        abi = [
          {
            "constant": true,
            "inputs": [],
            "name": "name",
            "outputs": [
              {"name": "", "type": "string"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "adminMask",
            "outputs": [
              {"name": "", "type": "bytes32"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "userMask",
            "outputs": [
              {"name": "", "type": "bytes32"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "entitiesList",
            "outputs": [
              {"name": "", "type": "address"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [
              {"name": "_name", "type": "string"}
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "constructor"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_entitiesList", "type": "address"}
            ],
            "name": "setEntitiesList",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [],
            "name": "join",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_account", "type": "address"},
              {"name": "_roles", "type": "bytes32"}
            ],
            "name": "addEntity",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_account", "type": "address"}
            ],
            "name": "removeEntity",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_account", "type": "address"},
              {"name": "_entityRoles", "type": "bytes32"}
            ],
            "name": "addEnitityRoles",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_account", "type": "address"},
              {"name": "_entityRoles", "type": "bytes32"}
            ],
            "name": "removeEnitityRoles",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {"name": "_account", "type": "address"},
              {"name": "_entityRoles", "type": "bytes32"}
            ],
            "name": "hasRoles",
            "outputs": [
              {"name": "", "type": "bool"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          }
        ];
        break;
      case "CommunityManager":
        abi = [
          {
            "constant": false,
            "inputs": [
              {"name": "_wallet", "type": "address"}
            ],
            "name": "init",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {"name": "_wallet", "type": "address"}
            ],
            "name": "getNonce",
            "outputs": [
              {"name": "nonce", "type": "uint256"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_wallet", "type": "address"},
              {"name": "_module", "type": "address"}
            ],
            "name": "addModule",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_token", "type": "address"}
            ],
            "name": "recoverToken",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_wallet", "type": "address"},
              {"name": "_data", "type": "bytes"},
              {"name": "_nonce", "type": "uint256"},
              {"name": "_signatures", "type": "bytes"},
              {"name": "_gasPrice", "type": "uint256"},
              {"name": "_gasLimit", "type": "uint256"}
            ],
            "name": "execute",
            "outputs": [
              {"name": "success", "type": "bool"}
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {"name": "", "type": "address"}
            ],
            "name": "relayer",
            "outputs": [
              {"name": "nonce", "type": "uint256"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "isOnlyOwnerModule",
            "outputs": [
              {"name": "", "type": "bytes4"}
            ],
            "payable": false,
            "stateMutability": "pure",
            "type": "function"
          },
          {
            "inputs": [
              {"name": "_registry", "type": "address"}
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "constructor"
          },
          {
            "anonymous": false,
            "inputs": [
              {"indexed": true, "name": "wallet", "type": "address"},
              {"indexed": true, "name": "success", "type": "bool"},
              {"indexed": false, "name": "signedHash", "type": "bytes32"}
            ],
            "name": "TransactionExecuted",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {"indexed": false, "name": "name", "type": "bytes32"}
            ],
            "name": "ModuleCreated",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {"indexed": false, "name": "wallet", "type": "address"}
            ],
            "name": "ModuleInitialised",
            "type": "event"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_wallet", "type": "address"},
              {"name": "_community", "type": "address"}
            ],
            "name": "joinCommunity",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          }
        ];
        break;
      case "TransferManager":
        abi = [
          {
            "constant": true,
            "inputs": [],
            "name": "securityWindow",
            "outputs": [
              {
                "name": "",
                "type": "uint256"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              }
            ],
            "name": "getNonce",
            "outputs": [
              {
                "name": "nonce",
                "type": "uint256"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              }
            ],
            "name": "getCurrentLimit",
            "outputs": [
              {
                "name": "_currentLimit",
                "type": "uint256"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              },
              {
                "name": "_module",
                "type": "address"
              }
            ],
            "name": "addModule",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              }
            ],
            "name": "getDailyUnspent",
            "outputs": [
              {
                "name": "_unspent",
                "type": "uint256"
              },
              {
                "name": "_periodEnd",
                "type": "uint64"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "securityPeriod",
            "outputs": [
              {
                "name": "",
                "type": "uint256"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "oldLimitManager",
            "outputs": [
              {
                "name": "",
                "type": "address"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "transferStorage",
            "outputs": [
              {
                "name": "",
                "type": "address"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_token",
                "type": "address"
              }
            ],
            "name": "recoverToken",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              }
            ],
            "name": "getPendingLimit",
            "outputs": [
              {
                "name": "_pendingLimit",
                "type": "uint256"
              },
              {
                "name": "_changeAfter",
                "type": "uint64"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              },
              {
                "name": "_data",
                "type": "bytes"
              },
              {
                "name": "_nonce",
                "type": "uint256"
              },
              {
                "name": "_signatures",
                "type": "bytes"
              },
              {
                "name": "_gasPrice",
                "type": "uint256"
              },
              {
                "name": "_gasLimit",
                "type": "uint256"
              }
            ],
            "name": "execute",
            "outputs": [
              {
                "name": "success",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "priceProvider",
            "outputs": [
              {
                "name": "",
                "type": "address"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {
                "name": "",
                "type": "address"
              }
            ],
            "name": "relayer",
            "outputs": [
              {
                "name": "nonce",
                "type": "uint256"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "isOnlyOwnerModule",
            "outputs": [
              {
                "name": "",
                "type": "bytes4"
              }
            ],
            "payable": false,
            "stateMutability": "pure",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "guardianStorage",
            "outputs": [
              {
                "name": "",
                "type": "address"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "defaultLimit",
            "outputs": [
              {
                "name": "",
                "type": "uint256"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [
              {
                "name": "_registry",
                "type": "address"
              },
              {
                "name": "_transferStorage",
                "type": "address"
              },
              {
                "name": "_guardianStorage",
                "type": "address"
              },
              {
                "name": "_priceProvider",
                "type": "address"
              },
              {
                "name": "_securityPeriod",
                "type": "uint256"
              },
              {
                "name": "_securityWindow",
                "type": "uint256"
              },
              {
                "name": "_defaultLimit",
                "type": "uint256"
              },
              {
                "name": "_oldLimitManager",
                "type": "address"
              }
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "constructor"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "wallet",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "target",
                "type": "address"
              },
              {
                "indexed": false,
                "name": "whitelistAfter",
                "type": "uint64"
              }
            ],
            "name": "AddedToWhitelist",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "wallet",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "target",
                "type": "address"
              }
            ],
            "name": "RemovedFromWhitelist",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "wallet",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "id",
                "type": "bytes32"
              },
              {
                "indexed": true,
                "name": "executeAfter",
                "type": "uint256"
              },
              {
                "indexed": false,
                "name": "token",
                "type": "address"
              },
              {
                "indexed": false,
                "name": "to",
                "type": "address"
              },
              {
                "indexed": false,
                "name": "amount",
                "type": "uint256"
              },
              {
                "indexed": false,
                "name": "data",
                "type": "bytes"
              }
            ],
            "name": "PendingTransferCreated",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "wallet",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "id",
                "type": "bytes32"
              }
            ],
            "name": "PendingTransferExecuted",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "wallet",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "id",
                "type": "bytes32"
              }
            ],
            "name": "PendingTransferCanceled",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "wallet",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "newLimit",
                "type": "uint256"
              },
              {
                "indexed": true,
                "name": "startAfter",
                "type": "uint64"
              }
            ],
            "name": "LimitChanged",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "wallet",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "token",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "amount",
                "type": "uint256"
              },
              {
                "indexed": false,
                "name": "to",
                "type": "address"
              },
              {
                "indexed": false,
                "name": "data",
                "type": "bytes"
              }
            ],
            "name": "Transfer",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "wallet",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "token",
                "type": "address"
              },
              {
                "indexed": false,
                "name": "amount",
                "type": "uint256"
              },
              {
                "indexed": false,
                "name": "spender",
                "type": "address"
              }
            ],
            "name": "Approved",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "wallet",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "to",
                "type": "address"
              },
              {
                "indexed": false,
                "name": "amount",
                "type": "uint256"
              },
              {
                "indexed": false,
                "name": "data",
                "type": "bytes"
              }
            ],
            "name": "CalledContract",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "wallet",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "success",
                "type": "bool"
              },
              {
                "indexed": false,
                "name": "signedHash",
                "type": "bytes32"
              }
            ],
            "name": "TransactionExecuted",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": false,
                "name": "name",
                "type": "bytes32"
              }
            ],
            "name": "ModuleCreated",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": false,
                "name": "wallet",
                "type": "address"
              }
            ],
            "name": "ModuleInitialised",
            "type": "event"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              }
            ],
            "name": "init",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              },
              {
                "name": "_token",
                "type": "address"
              },
              {
                "name": "_to",
                "type": "address"
              },
              {
                "name": "_amount",
                "type": "uint256"
              },
              {
                "name": "_data",
                "type": "bytes"
              }
            ],
            "name": "transferToken",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              },
              {
                "name": "_token",
                "type": "address"
              },
              {
                "name": "_to",
                "type": "address"
              },
              {
                "name": "_amount",
                "type": "uint256"
              },
              {
                "name": "_fee",
                "type": "uint256"
              },
              {
                "name": "_data",
                "type": "bytes"
              }
            ],
            "name": "transferTokenWithFee",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              },
              {
                "name": "_token",
                "type": "address"
              },
              {
                "name": "_spender",
                "type": "address"
              },
              {
                "name": "_amount",
                "type": "uint256"
              }
            ],
            "name": "approveToken",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              },
              {
                "name": "_contract",
                "type": "address"
              },
              {
                "name": "_value",
                "type": "uint256"
              },
              {
                "name": "_data",
                "type": "bytes"
              }
            ],
            "name": "callContract",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              },
              {
                "name": "_token",
                "type": "address"
              },
              {
                "name": "_contract",
                "type": "address"
              },
              {
                "name": "_amount",
                "type": "uint256"
              },
              {
                "name": "_data",
                "type": "bytes"
              }
            ],
            "name": "approveTokenAndCallContract",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              },
              {
                "name": "_target",
                "type": "address"
              }
            ],
            "name": "addToWhitelist",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              },
              {
                "name": "_target",
                "type": "address"
              }
            ],
            "name": "removeFromWhitelist",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              },
              {
                "name": "_token",
                "type": "address"
              },
              {
                "name": "_to",
                "type": "address"
              },
              {
                "name": "_amount",
                "type": "uint256"
              },
              {
                "name": "_data",
                "type": "bytes"
              },
              {
                "name": "_block",
                "type": "uint256"
              }
            ],
            "name": "executePendingTransfer",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              },
              {
                "name": "_id",
                "type": "bytes32"
              }
            ],
            "name": "cancelPendingTransfer",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              },
              {
                "name": "_newLimit",
                "type": "uint256"
              }
            ],
            "name": "changeLimit",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              }
            ],
            "name": "disableLimit",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              },
              {
                "name": "_target",
                "type": "address"
              }
            ],
            "name": "isWhitelisted",
            "outputs": [
              {
                "name": "_isWhitelisted",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {
                "name": "_wallet",
                "type": "address"
              },
              {
                "name": "_id",
                "type": "bytes32"
              }
            ],
            "name": "getPendingTransfer",
            "outputs": [
              {
                "name": "_executeAfter",
                "type": "uint64"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {
                "name": "_data",
                "type": "bytes"
              },
              {
                "name": "_signature",
                "type": "bytes"
              }
            ],
            "name": "isValidSignature",
            "outputs": [
              {
                "name": "",
                "type": "bytes4"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {
                "name": "_msgHash",
                "type": "bytes32"
              },
              {
                "name": "_signature",
                "type": "bytes"
              }
            ],
            "name": "isValidSignature",
            "outputs": [
              {
                "name": "",
                "type": "bytes4"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          }
        ];
        break;
      case "DAIPointsManager":
        abi = [
          {
            "constant": false,
            "inputs": [
              {"name": "_wallet", "type": "address"}
            ],
            "name": "init",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {"name": "_wallet", "type": "address"}
            ],
            "name": "getNonce",
            "outputs": [
              {"name": "nonce", "type": "uint256"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_manager", "type": "address"}
            ],
            "name": "addManager",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_manager", "type": "address"}
            ],
            "name": "revokeManager",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_wallet", "type": "address"},
              {"name": "_module", "type": "address"}
            ],
            "name": "addModule",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "owner",
            "outputs": [
              {"name": "", "type": "address"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_token", "type": "address"}
            ],
            "name": "recoverToken",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_newOwner", "type": "address"}
            ],
            "name": "changeOwner",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_wallet", "type": "address"},
              {"name": "_data", "type": "bytes"},
              {"name": "_nonce", "type": "uint256"},
              {"name": "_signatures", "type": "bytes"},
              {"name": "_gasPrice", "type": "uint256"},
              {"name": "_gasLimit", "type": "uint256"}
            ],
            "name": "execute",
            "outputs": [
              {"name": "success", "type": "bool"}
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "daiPoints",
            "outputs": [
              {"name": "", "type": "address"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {"name": "", "type": "address"}
            ],
            "name": "relayer",
            "outputs": [
              {"name": "nonce", "type": "uint256"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "isOnlyOwnerModule",
            "outputs": [
              {"name": "", "type": "bytes4"}
            ],
            "payable": false,
            "stateMutability": "pure",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "dai",
            "outputs": [
              {"name": "", "type": "address"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {"name": "", "type": "address"}
            ],
            "name": "managers",
            "outputs": [
              {"name": "", "type": "bool"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [
              {"name": "_registry", "type": "address"},
              {"name": "_dai", "type": "address"},
              {"name": "_daiPoints", "type": "address"}
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "constructor"
          },
          {
            "anonymous": false,
            "inputs": [
              {"indexed": true, "name": "_manager", "type": "address"}
            ],
            "name": "ManagerAdded",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {"indexed": true, "name": "_manager", "type": "address"}
            ],
            "name": "ManagerRevoked",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {"indexed": true, "name": "_newOwner", "type": "address"}
            ],
            "name": "OwnerChanged",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {"indexed": true, "name": "wallet", "type": "address"},
              {"indexed": true, "name": "success", "type": "bool"},
              {"indexed": false, "name": "signedHash", "type": "bytes32"}
            ],
            "name": "TransactionExecuted",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {"indexed": false, "name": "name", "type": "bytes32"}
            ],
            "name": "ModuleCreated",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {"indexed": false, "name": "wallet", "type": "address"}
            ],
            "name": "ModuleInitialised",
            "type": "event"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_wallet", "type": "address"},
              {"name": "_amount", "type": "uint256"}
            ],
            "name": "getDAIPoints",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_wallet", "type": "address"},
              {"name": "_amount", "type": "uint256"},
              {"name": "_recipient", "type": "address"}
            ],
            "name": "getDAIPointsToAddress",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_dai", "type": "address"}
            ],
            "name": "setDaiAddress",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {"name": "_daiPoints", "type": "address"}
            ],
            "name": "setDaiPointsAddress",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          }
        ];
        break;
      case "DAIPointsToken":
        abi = [
          {
            "constant": true,
            "inputs": [],
            "name": "name",
            "outputs": [
              {
                "name": "",
                "type": "string"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "spender",
                "type": "address"
              },
              {
                "name": "value",
                "type": "uint256"
              }
            ],
            "name": "approve",
            "outputs": [
              {
                "name": "",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "totalSupply",
            "outputs": [
              {
                "name": "",
                "type": "uint256"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "sender",
                "type": "address"
              },
              {
                "name": "recipient",
                "type": "address"
              },
              {
                "name": "amount",
                "type": "uint256"
              }
            ],
            "name": "transferFrom",
            "outputs": [
              {
                "name": "",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "daiToDaipConversionRate",
            "outputs": [
              {
                "name": "",
                "type": "uint256"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "DECIMALS",
            "outputs": [
              {
                "name": "",
                "type": "uint256"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "decimals",
            "outputs": [
              {
                "name": "",
                "type": "uint8"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "spender",
                "type": "address"
              },
              {
                "name": "addedValue",
                "type": "uint256"
              }
            ],
            "name": "increaseAllowance",
            "outputs": [
              {
                "name": "",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_to",
                "type": "address"
              },
              {
                "name": "_value",
                "type": "uint256"
              },
              {
                "name": "_data",
                "type": "bytes"
              }
            ],
            "name": "transferAndCall",
            "outputs": [
              {
                "name": "",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "account",
                "type": "address"
              },
              {
                "name": "amount",
                "type": "uint256"
              }
            ],
            "name": "mint",
            "outputs": [
              {
                "name": "",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "amount",
                "type": "uint256"
              }
            ],
            "name": "burn",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {
                "name": "account",
                "type": "address"
              }
            ],
            "name": "balanceOf",
            "outputs": [
              {
                "name": "",
                "type": "uint256"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [],
            "name": "renounceOwnership",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "account",
                "type": "address"
              },
              {
                "name": "amount",
                "type": "uint256"
              }
            ],
            "name": "burnFrom",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "owner",
            "outputs": [
              {
                "name": "",
                "type": "address"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "isOwner",
            "outputs": [
              {
                "name": "",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "symbol",
            "outputs": [
              {
                "name": "",
                "type": "string"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "account",
                "type": "address"
              }
            ],
            "name": "addMinter",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [],
            "name": "renounceMinter",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "spender",
                "type": "address"
              },
              {
                "name": "subtractedValue",
                "type": "uint256"
              }
            ],
            "name": "decreaseAllowance",
            "outputs": [
              {
                "name": "",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {
                "name": "account",
                "type": "address"
              }
            ],
            "name": "isMinter",
            "outputs": [
              {
                "name": "",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [
              {
                "name": "owner",
                "type": "address"
              },
              {
                "name": "spender",
                "type": "address"
              }
            ],
            "name": "allowance",
            "outputs": [
              {
                "name": "",
                "type": "uint256"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "fee",
            "outputs": [
              {
                "name": "",
                "type": "uint256"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "bridge",
            "outputs": [
              {
                "name": "",
                "type": "address"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "newOwner",
                "type": "address"
              }
            ],
            "name": "transferOwnership",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "dai",
            "outputs": [
              {
                "name": "",
                "type": "address"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [
              {
                "name": "_dai",
                "type": "address"
              }
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "constructor"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "previousOwner",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "newOwner",
                "type": "address"
              }
            ],
            "name": "OwnershipTransferred",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "account",
                "type": "address"
              }
            ],
            "name": "MinterAdded",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "account",
                "type": "address"
              }
            ],
            "name": "MinterRemoved",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": false,
                "name": "success",
                "type": "bool"
              },
              {
                "indexed": false,
                "name": "data",
                "type": "bytes"
              }
            ],
            "name": "ContractFallback",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "from",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "to",
                "type": "address"
              },
              {
                "indexed": false,
                "name": "value",
                "type": "uint256"
              },
              {
                "indexed": false,
                "name": "data",
                "type": "bytes"
              }
            ],
            "name": "Transfer",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "from",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "to",
                "type": "address"
              },
              {
                "indexed": false,
                "name": "value",
                "type": "uint256"
              }
            ],
            "name": "Transfer",
            "type": "event"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "owner",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "spender",
                "type": "address"
              },
              {
                "indexed": false,
                "name": "value",
                "type": "uint256"
              }
            ],
            "name": "Approval",
            "type": "event"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_address",
                "type": "address"
              }
            ],
            "name": "setDAI",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_fee",
                "type": "uint256"
              }
            ],
            "name": "setFee",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_address",
                "type": "address"
              }
            ],
            "name": "setBridge",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_rate",
                "type": "uint256"
              }
            ],
            "name": "setConversionRate",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_amount",
                "type": "uint256"
              }
            ],
            "name": "getDAIPoints",
            "outputs": [
              {
                "name": "",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_amount",
                "type": "uint256"
              },
              {
                "name": "_recipient",
                "type": "address"
              }
            ],
            "name": "getDAIPointsToAddress",
            "outputs": [
              {
                "name": "",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_recipient",
                "type": "address"
              },
              {
                "name": "_amount",
                "type": "uint256"
              }
            ],
            "name": "transfer",
            "outputs": [
              {
                "name": "",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_winner",
                "type": "address"
              }
            ],
            "name": "reward",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          }
        ];
        break;
      case "Wrapper":
        abi = [
          {
            "constant": false,
            "inputs": [],
            "name": "renounceOwnership",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "owner",
            "outputs": [
              {
                "name": "",
                "type": "address"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "isOwner",
            "outputs": [
              {
                "name": "",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "newOwner",
                "type": "address"
              }
            ],
            "name": "transferOwnership",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "anonymous": false,
            "inputs": [
              {
                "indexed": true,
                "name": "previousOwner",
                "type": "address"
              },
              {
                "indexed": true,
                "name": "newOwner",
                "type": "address"
              }
            ],
            "name": "OwnershipTransferred",
            "type": "event"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_token",
                "type": "address"
              },
              {
                "name": "_recipient",
                "type": "address"
              },
              {
                "name": "_amount",
                "type": "uint256"
              },
              {
                "name": "_feeRecipient",
                "type": "address"
              },
              {
                "name": "_feeAmount",
                "type": "uint256"
              }
            ],
            "name": "transferWithFee",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "name": "_token",
                "type": "address"
              },
              {
                "name": "_recipient",
                "type": "address"
              },
              {
                "name": "_amount",
                "type": "uint256"
              },
              {
                "name": "_feeRecipient",
                "type": "address"
              },
              {
                "name": "_feeAmount",
                "type": "uint256"
              },
              {
                "name": "_data",
                "type": "bytes"
              }
            ],
            "name": "transferAndCallWithFee",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          }
        ];
        break;
      default:
        throw 'ABI does not exists for $name';
    }

    return jsonEncode(abi);
  }
}
