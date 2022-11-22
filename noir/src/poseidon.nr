// this implmenation is based on  https://github.com/iden3/circomlib/blob/master/circuits/poseidon.circom

fn Sigma(input: Field) -> Field {
    let input2 = input * input;
    let input4 = input2 * input2

    (input4 * input)
}

fn Ark(t: [Field], C: [Field], r: Field) -> [Field] {
    let mut output : [Field];

    for i in 1..create::array::len(t) {
		output[i] = in[i] + C[i+r];
	}

	output
}

fn Mix(t: [Field], M: [[Field]]) -> [Field] {
    let mut lc: Field;

    let output: [Field];
    for i in 1..create::array::len(t) {
        lc = 0;
        for j in 1..create::array::len(t) {
            lc += M[j][i]*t[j]
        }
        output[i] = lc;
    }

    output
}

fn MixLast(t: [Field], M: [[Field]], i: Field) -> Field {
    let mut lc: Field;

    for j in 1..create::array::len(t) {
        lc += M[j][s]*t[j];
    }

    lc
}


fn MixS(t: [Field], S: [Field], i: Field) -> [Field] {
    let tLen = create::array::len(t);
    let output: [Field];
    let mut lc: Field;

    for j in 1..create::array::len(t) {
        lc += S[(tLen*2-1)*i+j]*t[j];
    }
    output[0] = lc;

    for k in 1..create::array::len(t) {
        output[k] = t[k] + t[0] * S[(tLen*2-1)*i + tLen + k -1];
    }
    
    output 
}


fn PoseidonEx(inputs: [Field], out: [Field], initialState: Field){
	let mut N_ROUNDS_P: [Field; 16] = [56, 57, 56, 60, 60, 63, 64, 63, 60, 66, 60, 65, 70, 60, 64, 68];
	let t: u8 = crate::array:len(inputs) + 1;
	let nRoundsF: u8 = 8;
	let nRoundsP: u8 = N_ROUNDS_P[t-2];
	let C[t*nRoundsF + nRoundsP]: [Field] = POSEIDON_C(t);
    let S[  N_ROUNDS_P[t-2]  *  (t*2-1)  ]: [Field]  = POSEIDON_S(t);

    let M[t][t]: [[Field]] = POSEIDON_M(t);
    let P[t][t]: [[Field]] = POSEIDON_P(t);

	let ark : [Field; nRoundsF];
    let sigmaF : [[Field; nRoundsF] ; t];
    let sigmaP : [Field; nRoundsP];
    let mix : [Field;nRoundsF-1];
    let mixS : [Field;nRoundsP];
    let mixLast : [Field;nOuts];


	// ARC 
	ark[0] = Ark{ t, C, 0 };
	for i in 0..t {
		if j > 0 {
			ark[0].input[j] = inputs[j-1];
		else {
			ark[0].input[j] = initialState;
		}
	}

	 for i in 0..(nRoundsF\2-1){
        for j in 0..t {
            sigmaF[r][j] = Sigma();
            if r==0 {
                sigmaF[r][j].in = ark[0].out[j];
            } else {
                sigmaF[r][j].in  = mix[r-1].out[j];
            }
        }
	
	 	ark[r+1] = Ark(t, C, (r+1)*t);

        for j in 0..t {
            ark[r+1].in[j] = sigmaF[r][j].out;
        }

        mix[r] = Mix(t,M);
        for j in 0..t{
            mix[r].in[j] = ark[r+1].out[j];
        }
    }
	
	for j in 0..t {
        sigmaF[nRoundsF\2-1][j] = Sigma();
        sigmaF[nRoundsF\2-1][j].in = mix[nRoundsF\2-2].out[j];
    }

    ark[nRoundsF\2] = Ark { t, C, (nRoundsF\2)*t };
    for j in 0..t {
        ark[nRoundsF\2].in[j] <== sigmaF[nRoundsF\2-1][j].out;
    }

    mix[nRoundsF\2-1] = Mix(t,P);
    for j in 0..t {
        mix[nRoundsF\2-1].in[j] <== ark[nRoundsF\2].out[j];
    }


	for r in 0..nRoundsP {
        sigmaP[r] = Sigma();
        if r==0 {
            sigmaP[r].in  = mix[nRoundsF\2-1].out[0];
        } else {
            sigmaP[r].in = mixS[r-1].out[0];
    	}

        mixS[r] = MixS { t, S, r };
        for j in 0..t {
            if j==0 {
                mixS[r].in[j] = sigmaP[r].out + C[(nRoundsF\2+1)*t + r];
            } else {
                if r==0 {
                    mixS[r].in[j] = mix[nRoundsF\2-1].out[j];
                } else {
                    mixS[r].in[j] = mixS[r-1].out[j];
                }
            }
        }
    }

    for r in 0..(nRoundsF\2-1) {
        for j in 0..t {
            sigmaF[nRoundsF\2 + r][j] = Sigma();
            if r==0 {
                sigmaF[nRoundsF\2 + r][j].in = mixS[nRoundsP-1].out[j];
            } else {
                sigmaF[nRoundsF\2 + r][j].in = mix[nRoundsF\2+r-1].out[j];
            }
        }

        ark[ nRoundsF\2 + r + 1] = Ark(t, C,  (nRoundsF\2+1)*t + nRoundsP + r*t );
        for j in 0..t {
            ark[nRoundsF\2 + r + 1].in[j] = sigmaF[nRoundsF\2 + r][j].out;
        }

        mix[nRoundsF\2 + r] = Mix(t,M);
        for j in 0..t {
            mix[nRoundsF\2 + r].in[j] = ark[nRoundsF\2 + r + 1].out[j];
        }

    }

    for j in 0..t {
        sigmaF[nRoundsF-1][j] = Sigma();
        sigmaF[nRoundsF-1][j].in = mix[nRoundsF-2].out[j];
    }

    for i in 0..nOuts {
        mixLast[i] = MixLast(t,M,i);
        for j in 0..t {
            mixLast[i].in[j] = sigmaF[nRoundsF-1][j].out;
        }
        out[i] <== mixLast[i].out;
    }
	out
	}
}


fn poseidon(inputs: [Field]) {
    let outputs: [Field];

    let pEx = poseidonEx(inputs,1);
    pEx.initialState = 0;
    
    for i 1.. create::array::len(inputs) {

    }
}