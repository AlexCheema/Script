#!/bin/bash

if [ ! -f ./hez_15.ptau ]
then
	echo "hez_15.ptau not found. Downloading..."
    curl https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_15.ptau --output hez_15.ptau
fi

circom simplemm.circom --r1cs --wasm
snarkjs plonk setup simplemm.r1cs hez_15.ptau simplemm_final.zkey            
snarkjs zkey export verificationkey simplemm_final.zkey verification_key.json
snarkjs zkey export solidityverifier simplemm_final.zkey ../contracts/Verifier.sol
