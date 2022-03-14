pragma circom 2.0.0;
include "./node_modules/circomlib/circuits/mimcsponge.circom";


template MerkleRoot(n) {
    // define leaves input signal of type array
    signal input leaves[n];
    // output public signal root for root of merkle tree
    signal output root;
    // total node in tree
    var node = 2*n-1;
    // array to represent the entire tree
    signal merkle_tree[node];
    // first level where the leaves start
    var start_node = n-1;
    // hashes
    component mimcHash[node];
    // loop to compute the hashes of each node
    for (var i=node-1; i>=0; i--){
        // if it's a leaf, get the hash
        if (i >= start_node){
            // MiMCSponge hash fn
            mimcHash[i] = MiMCSponge(1,220,1);
            // set k to zero
            mimcHash[i].k <== 0;
            // leaf to be hashed
            mimcHash[i].ins[0] <== leaves[i-start_node];
        }else{
            // if its not a leaf condition
            // hasher fn
            mimcHash[i]= MiMCSponge(2, 220, 1);
            // set k to zero
            mimcHash[i].k <== 0;
            // get hashes left and right child in to the hasher
            mimcHash[i].ins[0] <== merkle_tree[2 *i+1];
            mimcHash[i].ins[1] <== merkle_tree[2*i+2];
        }
        // place the hash in the tree position
        merkle_tree[i] <== mimcHash[i].outs[0];
    }
    //return the root hash
    root <== merkle_tree[0];   
}

component main {public [leaves]} = MerkleRoot(8);
