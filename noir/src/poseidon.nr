fn sigma(input: Field) -> Field {
    let input2 = input * input;
    let input4 = input2 * input2

    (input4 * input)
}

fn ark(t: [Field], C: [Field], r: Field) -> [Field] {
    let mut output : [Field];

    for i in 1..create::array::len(t) {
		output[i] = in[i] + C[i+r];
	}

	output
}

fn mix(t: [Field], M: [[Field]]) -> [Field] {
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

fn mixLast(t: [Field], M: [[Field]], i: Field) -> Field {
    let mut lc: Field;

    for j in 1..create::array::len(t) {
        lc += M[j][s]*t[j];
    }

    lc
}


fn mixS(t: [Field], S: [Field], i: Field) -> [Field] {
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

fn poseidonEx(inputs: [Field], nOuts: Field) {}

fn poseidon(inputs: [Field]) {}