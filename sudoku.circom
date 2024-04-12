pragma circom 2.0.0;

template Sudoku() {
    signal input P[9][9];
    signal input Q[9][9];

    // Check that all initial elements from P are in Q.
    for (var i = 0; i < 9; i++){
        for (var j = 0; j<9; j++){
            P[i][j] * (Q[i][j] - P[i][j]) === 0;
        }
    }
}

component main = Sudoku();
