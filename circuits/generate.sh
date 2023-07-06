circom simplemm.circom --r1cs --wasm
snarkjs plonk setup simplemm.r1cs hez_15.ptau simplemm_final.zkey            
snarkjs zkey export verificationkey simplemm_final.zkey verification_key.json
snarkjs zkey export solidityverifier simplemm_final.zkey ../contracts/Verifier.sol
