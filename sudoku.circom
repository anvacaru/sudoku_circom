pragma circom 2.0.0;

template CheckInRange() {
    signal input in;
    signal v[10];
    v[0] <== 1;
    for (var i = 1; i <= 9; i++){
        v[i] <== v[i-1] * (in - i);
    }
    v[9] === 0;
}

template PermutationCheck(){
    signal input in[9];
    signal v[10];
    v[0] <== 1;
    var product = 1 * 2 * 3 * 4 * 5 * 6 * 7 * 8 * 9;
    for (var i = 1; i <= 9; i++){
        v[i] <== v[i-1] * (in[i-1]);
    }
    v[9] === product;
}

template Sudoku() {
    signal input P[9][9];
    signal input Q[9][9];

    // Check that all initial elements from P are in Q.
    for (var i = 0; i < 9; i++){
        for (var j = 0; j < 9; j++){
            P[i][j] * (Q[i][j] - P[i][j]) === 0;
        }
    }

    // Check that all numbers in Q are in [1,9]
    //             assert(Q[i][j] >= 1);
    //            assert(Q[i][j] <= 9);
    for (var i = 0; i < 9; i++){
        for (var j = 0; j < 9; j++){
            CheckInRange()(in <== Q[i][j]);
        }
    }

    // Check that no number repeats on a line
    // assert(Q[row][i] != Q[row][j]);
    for (var row = 0; row < 9; row++){
            PermutationCheck()(in <== Q[row]);
    }

    // Check that no number repeats on a column
    // assert(Q[i][col] != Q[j][col]);
    for (var col = 0; col < 9; col++){
        var column[9];
        for (var i = 0; i < 9; i++){
            column[i] = Q[i][col];
        }
        PermutationCheck()(in <== column);
    }

    // Define 9 arrays with the elements of each sub-square
    var square_1[9] = [Q[0][0], Q[0][1], Q[0][2], Q[1][0], Q[1][1], Q[1][2], Q[2][0], Q[2][1], Q[2][2]];
    var square_2[9] = [Q[0][3], Q[0][4], Q[0][5], Q[1][3], Q[1][4], Q[1][5], Q[2][3], Q[2][4], Q[2][5]];
    var square_3[9] = [Q[0][6], Q[0][7], Q[0][8], Q[1][6], Q[1][7], Q[1][8], Q[2][6], Q[2][7], Q[2][8]];
    
    var square_4[9] = [Q[3][0], Q[3][1], Q[3][2], Q[4][0], Q[4][1], Q[4][2], Q[5][0], Q[5][1], Q[5][2]];
    var square_5[9] = [Q[3][3], Q[3][4], Q[3][5], Q[4][3], Q[4][4], Q[4][5], Q[5][3], Q[5][4], Q[5][5]];
    var square_6[9] = [Q[3][6], Q[3][7], Q[3][8], Q[4][6], Q[4][7], Q[4][8], Q[5][6], Q[5][7], Q[5][8]];

    var square_7[9] = [Q[6][0], Q[6][1], Q[6][2], Q[7][0], Q[7][1], Q[7][2], Q[8][0], Q[8][1], Q[8][2]];
    var square_8[9] = [Q[6][3], Q[6][4], Q[6][5], Q[7][3], Q[7][4], Q[7][5], Q[8][3], Q[8][4], Q[8][5]];
    var square_9[9] = [Q[6][6], Q[6][7], Q[6][8], Q[7][6], Q[7][7], Q[7][8], Q[8][6], Q[8][7], Q[8][8]];

    // Define an array with the previously defined arrays
    var squares [9][9]=[square_1, square_2, square_3, square_4, square_5, square_6, square_7, square_8, square_9];

    // Assert that for each square array, elements do not repeat.
    // assert(squares[idx][i]!=squares[idx][j]);
    for(var idx = 0; idx < 9; idx++) {
        PermutationCheck()(in <== squares[idx]);
    }
}

component main{public[P]} = Sudoku();
