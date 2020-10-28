export const address: string = "4RFegSDdS1bYggrsrHZjwYtob11eKSu1CvLfobNx5VXmRwNBnYLpyyeSZTU3THCDWi7Pa4pMyPsKuqSow23gidYZ";
export const address1: string = "CZAjwxwJhbkxsJHoqTcKZNti4XyCtec182Ys2EHx4SuHEYHY76hk5hLNi1EhuQJkoAdRrDxEg6EVMpVEkzemVWv";
export const abi: any =[
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "seedToken",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "index",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "currentTime",
				"type": "uint256"
			}
		],
		"name": "calWithdrawIndex",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "begin",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "end",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "exchange",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "len",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "myExchangeValue",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "backedValue",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "withDrawValue",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "returnValue",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "myRecordInfo",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "index",
						"type": "uint256"
					},
					{
						"components": [
							{
								"internalType": "address",
								"name": "owner",
								"type": "address"
							},
							{
								"internalType": "uint256",
								"name": "createTime",
								"type": "uint256"
							},
							{
								"internalType": "uint256",
								"name": "lastWithDrawTime",
								"type": "uint256"
							},
							{
								"internalType": "uint256",
								"name": "total",
								"type": "uint256"
							}
						],
						"internalType": "struct SeedMixSwap.Record",
						"name": "data",
						"type": "tuple"
					}
				],
				"internalType": "struct SeedMixSwap.RecordInfo[]",
				"name": "result",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "myValidRecordInfo",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "index",
						"type": "uint256"
					},
					{
						"components": [
							{
								"internalType": "address",
								"name": "owner",
								"type": "address"
							},
							{
								"internalType": "uint256",
								"name": "createTime",
								"type": "uint256"
							},
							{
								"internalType": "uint256",
								"name": "lastWithDrawTime",
								"type": "uint256"
							},
							{
								"internalType": "uint256",
								"name": "total",
								"type": "uint256"
							}
						],
						"internalType": "struct SeedMixSwap.Record",
						"name": "data",
						"type": "tuple"
					}
				],
				"internalType": "struct SeedMixSwap.RecordInfo[]",
				"name": "result",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "pause",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "records",
		"outputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "createTime",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "lastWithDrawTime",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "total",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bool",
				"name": "_pause",
				"type": "bool"
			}
		],
		"name": "setPause",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "newAddress",
				"type": "address"
			}
		],
		"name": "transferSeed",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "index",
				"type": "uint256"
			}
		],
		"name": "withDraw",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"stateMutability": "payable",
		"type": "receive"
	}
]
export const abi1:any=[
	{
		"inputs": [],
		"name": "totalSupply",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
