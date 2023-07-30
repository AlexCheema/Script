#!/bin/bash

CIRCUIT=${CIRCUIT:-simplemm}

if [ ! -f ./hez_15.ptau ]
then
	echo "hez_15.ptau not found. Downloading..."
    curl https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_15.ptau --output hez_15.ptau
fi

circom ${CIRCUIT}.circom --r1cs --wasm
snarkjs plonk setup ${CIRCUIT}.r1cs hez_15.ptau ${CIRCUIT}_final.zkey
snarkjs zkey export verificationkey ${CIRCUIT}_final.zkey verification_key.json
snarkjs zkey export solidityverifier ${CIRCUIT}_final.zkey ../contracts/Verifier.sol
