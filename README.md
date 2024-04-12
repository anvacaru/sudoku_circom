# ZK Challenge for the Bucharest Hackathon (Last Update: 2024/4/10)

**Title**:
Sudoku in Zero Knowledge

**Background**:
[Sudoku](https://en.wikipedia.org/wiki/Sudoku) is a game that's played by filling a 9 x 9 grid with digits
such that each row, each column, and each of the nine 3 x 3 subgrids contains all of the digits from 1 to 9.

Sudoku puzzles started to appear in newspapers in the late 19th century and gathered great interest from the readers. However, the editors of the newspapers didn't know much about producing or solving Sudoku puzzles, so they wanted enthusiastic readers to produce them. On the other hand, a puzzle creator didn't want to leak a solution too early, either. How could the editors of the newspapers verify that a Sudoku puzzle has a solution without knowing what the solution is?

In this challenge, you'll help the newspaper editors and Sudoku puzzle creators by developing a zero-knowledge proof system. Using your proof system, a puzzle creator can produce, for a given Sudoku puzzle `P`, a zero-knowledge proof (ZKP) `pi` that verifies to any third party (i.e., newspaper editors) that `P` has a solution. This way, the editors feel safe to publish `P` in their most liked "Sudoku of the Day" column knowing that `P` is a valid puzzle, while the puzzle creator keeps the solution(s) to themselves.

You will be using `circom` ([link](https://docs.circom.io/)) to build the zero-knowledge proof system and generate ZKPs. 
The official circom website has clear installation instructions and a few simple examples to help you get started. 
You will use circom to build an [arithmetic circuit](https://docs.circom.io/background/background/#arithmetic-circuits) that takes a Sudoku puzzle `P` as input, checks `P` has a solution, and uses `circom`'s toolchain to produce the ZKP. 

**Deliverable**:

Use circom to write a circuit `Sudoku(P[9][9], ARGs)` where the first argument `P`
is an array that encodes a Sudoku problem, with `P[i][j]` being the digit in the (i,j)-th cell 
(i.e., the cell in the i-th row and the j-th column).
If an (i,j)-cell is empty, let `P[i][j]` be 0.
The circuit `Sudoku` is allowed to take other input arguments, denoted `ARGs`, 
but the only public input argument is `P`.
For more about public/private arguments,
refer to [this section](https://docs.circom.io/circom-language/signals/#public-and-private-signals).

The circuit `Sudoku` should satisfy the following soundness and completeness properties.
Let `P` be a any Sudoku problem as the public input.
Let `ZKverify` be the ZK verifier as described at [here](https://docs.circom.io/getting-started/proving-circuits/#verifying-a-proof),
where `public.json` is `P` and `proof.json` is `pi`. 

1. (Completeness)
   If `P` has a solution, then there exists some `ARGS` such that 
   `Sudoku(P, ARGS)` completes successfully.
   Therefore, for the proof `pi` produced by running the `circom`+`snarkjs` pipeline
   over the `Sudoku(P, ARGS)` circuit, we can obtain that `ZKverify(P, pi) = OK`.

2. (Soundness)
   If `P` does not have a solution, then for any ZK proof `pi*` produced by a cheating prover,
   `ZKverify(P, pi*) = OK` with a negligible probability.

**Hints**:
To satisfy (Completeness), you essentially need to ensure that
for any `ARGs`, if `Soduku(P, ARGs)` checks then `P` has a solution.
To satisfy (Soundness), we encourage all participants to share their implementations
of the circuit `Soduku` and try to find security issues in their competitors' solutions.
