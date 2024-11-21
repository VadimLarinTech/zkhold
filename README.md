# zkhold

zk-SNARK Demo: Verifying Token Ownership Without Revealing Wallet Details
Description

This is a demo application utilizing zk-SNARKs to verify that a user owns a token balance greater than a specified threshold without revealing their wallet address or exact balance.

The project consists of:

- Circuit (Scheme) defining mathematical constraints.
- Smart Contract to verify zk-SNARK proofs.
- Sample data and instructions for proof generation.

# How to Use
## 1. Install Dependencies

Ensure you have the following installed:

- Node.js (version 16 or higher).
- circom and snarkjs:


```
npm install -g circom snarkjs
```
## 2. Generate zk-SNARK Proof

#### 1. Compile the Circuit (if necessary):

```
circom circuits/TokenOwnership.circom --r1cs --wasm --sym -o circuits/
```

#### 2. Setup Powers of Tau:

```
snarkjs powersoftau new bn128 12 circuits/pot12_0000.ptau
snarkjs powersoftau contribute circuits/pot12_0000.ptau circuits/pot12_0001.ptau --name="Initial Contribution"
```

#### 3. Generate zk-SNARK Keys:

```
snarkjs groth16 setup circuits/TokenOwnership.r1cs circuits/pot12_0001.ptau circuits/circuit_final.zkey
snarkjs zkey contribute circuits/circuit_final.zkey circuits/circuit_final_with_contribution.zkey --name="My Contribution"
snarkjs zkey export verificationkey circuits/circuit_final_with_contribution.zkey circuits/verification_key.json
```

#### 4. Prepare Input Data: Create a file `input.json`:

```
{
    "balance": 50000000000000000,
    "threshold": 30000000000000000,
    "pubHash": 45012802638269721258729196075222448930598861202609039866515015310532977100201,
    "walletHash": 45012802638269721258729196075222448930598861202609039866515015310532977100201
}
```

#### 5. Generate Proof:

```
snarkjs groth16 fullprove input.json circuits/TokenOwnership_js/TokenOwnership.wasm circuits/circuit_final_with_contribution.zkey proof.json public.json
```

## 3. Deploy the Smart Contract

#### 1. Deploy the Contract: Use Remix or the provided deployment script `deploy.js` (in the `scripts` directory):

```
node scripts/deploy.js
```
#### 2. Copy the deployed contract address for later use.

## 4. Verify Proof via Smart Contract

#### 1. Open the `proof.json` and `public.json` files. Pass the values into the smart contract function `verifyProof`:

- `a`: First two values from `proof.json` → `pi_a`.
- `b`: Values from `pi_b` in `proof.json`.
- `c`: First two values from `proof.json` → `pi_c`.
- `input`: Array from `public.json`.

#### 2. Example Input in Remix:
- Field `a`:
```
[535669297310286343031199409293873846561697113126356993973493772031588235479, 13130041843137469753785161217052139194820803848243123203703270861422815184809]
```
- Field `b`:
```
[[281478286131899021736383437301572654586700911178768603336669191512208840116, 12158579471745408589905123484313769478057217062295726094024691306604949815742], [8439841420151531405968286361876926797445246370965546227782776395786117213035, 16637498300161472870783807088793047028206408529666247822353787180723834656629]]
```
- Field `c`:
```
[11559732032986387107991004021392285783925812861821192530917403151452391805634, 10857046999023057135944570762232829481370756359578518086990519993285655852781]
```
- Field `input`:
```
[19115817855303379911708798262402794099346355232429559333912544385534608785578]
```

#### 3. Expected Output: If the proof is valid, the verifyProof function will return true.

# Example Usage

    Generate a zk-SNARK proof for a given token balance.
    Send the proof to the smart contract.
    Verify the proof without revealing the wallet address or balance.

# Useful Commands
- Recreate the witness:
```
node TokenOwnership_js/generate_witness.js circuits/TokenOwnership_js/TokenOwnership.wasm input.json witness.wtns
```
- Inspect the circuit:
```
snarkjs r1cs info circuits/TokenOwnership.r1cs
```