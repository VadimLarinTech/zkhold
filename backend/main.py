from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from web3 import Web3

app = FastAPI()

# Web3 провайдер (замените на ваш Infura/Alchemy URL)
INFURA_URL = "https://sepolia.infura.io/v3/bec89c14c9164bfca7ede574083822bb"
w3 = Web3(Web3.HTTPProvider(INFURA_URL))

# Контрактные данные
CONTRACT_ADDRESS = "0xaE8d64F86EA95A740A072D8E76857385F91cA175"  # Укажите адрес контракта
ABI = [
	{
		"inputs": [
			{
				"internalType": "uint256[2]",
				"name": "a",
				"type": "uint256[2]"
			},
			{
				"internalType": "uint256[2][2]",
				"name": "b",
				"type": "uint256[2][2]"
			},
			{
				"internalType": "uint256[2]",
				"name": "c",
				"type": "uint256[2]"
			},
			{
				"internalType": "uint256[]",
				"name": "input",
				"type": "uint256[]"
			}
		],
		"name": "verifyProof",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "pure",
		"type": "function"
	}
]

contract = w3.eth.contract(address=CONTRACT_ADDRESS, abi=ABI)


# Модель для входных данных
class ProofRequest(BaseModel):
    proof: dict
    public_signals: list


@app.post("/verify")
async def verify_proof(data: ProofRequest):
    try:
        proof = data.proof
        public_signals = data.public_signals

        # Вызов метода контракта для проверки
        result = contract.functions.verifyProof(
            proof["a"], proof["b"], proof["c"], public_signals
        ).call()

        return {"valid": result}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
