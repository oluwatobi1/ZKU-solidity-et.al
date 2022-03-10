circom merkle.circom --r1cs --wasm --sym --c

cp input.json merkle_js/input.json
cd merkle_js

node generate_witness.js merkle.wasm input.json witness.wtns


cp witness.wtns ../witness.wtns
cd ..
# First, we start a new "powers of tau" ceremony:

snarkjs powersoftau new bn128 12 pot12_0000.ptau -v

# Then, we contribute to the ceremony:

snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v

# phase2:
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v

# Execute the following command to start a new zkey:
snarkjs groth16 setup merkle.r1cs pot12_final.ptau merkle_0000.zkey

# Contribute to the phase 2 of the ceremony:
snarkjs zkey contribute merkle_0000.zkey merkle_0001.zkey --name="1st Contributor Name" -v

# Export the verification key:
snarkjs zkey export verificationkey merkle_0001.zkey verification_key.json

# generate a zk-proof associated to the circuit and the witness:
snarkjs groth16 prove merkle_0001.zkey witness.wtns proof.json public.json

# To verify the proof, execute the following command:
snarkjs groth16 verify verification_key.json public.json proof.json

# First, we need to generate the Solidity code using the command:
snarkjs zkey export solidityverifier merkle_0001.zkey verifier.sol


