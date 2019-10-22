/* C++ program to solve N Queen Problem using Branch 
and Bound */

class nqueen{
	
	int N;
	
	nqueen(int n){
		N=n;
	}
/* A utility function to print solution */
	void printSolution(int board[][])
    {
        for (int i = 0; i < N; i++)
        {
            for (int j = 0; j < N; j++)
                System.out.print(" " + board[i][j]
                        + " ");
            System.out.println();
        }
    } 

/* A Optimized function to check if a queen can 
be placed on board[row][col] */
boolean isSafe(int row, int col, int slashCode[][], 
			int backslashCode[][], boolean rowLookup[], 
			boolean slashCodeLookup[], boolean backslashCodeLookup[] ) 
{ 
	if (slashCodeLookup[slashCode[row][col]] || 
		backslashCodeLookup[backslashCode[row][col]] || 
		rowLookup[row]) 
	return false; 

	return true; 
} 

/* A recursive utility function to solve N Queen problem */
boolean solveNQueensUtil(int board[][], int col, 
	int slashCode[][], int backslashCode[][], boolean rowLookup[], 
	boolean slashCodeLookup[], boolean backslashCodeLookup[] ) 
{ 
	/* base case: If all queens are placed 
	then return true */
	if (col >= N) 
		return true; 

	/* Consider this column and try placing 
	this queen in all rows one by one */
	for (int i = 0; i < N; i++) 
	{ 
		/* Check if queen can be placed on 
		board[i][col] */
		if ( isSafe(i, col, slashCode, backslashCode, rowLookup, 
					slashCodeLookup, backslashCodeLookup) ) 
		{ 
			/* Place this queen in board[i][col] */
			board[i][col] = 1; 
			rowLookup[i] = true; 
			slashCodeLookup[slashCode[i][col]] = true; 
			backslashCodeLookup[backslashCode[i][col]] = true; 

			/* recur to place rest of the queens */
			if ( solveNQueensUtil(board, col + 1, slashCode, backslashCode, 
					rowLookup, slashCodeLookup, backslashCodeLookup) ) 
				return true; 

			/* If placing queen in board[i][col] 
			doesn't lead to a solution, then backtrack */

			/* Remove queen from board[i][col] */
			board[i][col] = 0; 
			rowLookup[i] = false; 
			slashCodeLookup[slashCode[i][col]] = false; 
			backslashCodeLookup[backslashCode[i][col]] = false; 
		} 
	} 

	/* If queen can not be place in any row in 
		this colum col then return false */
	return false; 
} 

/* This function solves the N Queen problem using 
Branch and Bound. It mainly uses solveNQueensUtil() to 
solve the problem. It returns false if queens 
cannot be placed, otherwise return true and 
prints placement of queens in the form of 1s. 
Please note that there may be more than one 
solutions, this function prints one of the 
feasible solutions.*/
boolean solveNQueens(int N) 
{ 
	int[][] board = new int[N][N]; 

	// helper matrices 
	int[][] slashCode = new int[N][N]; 
	int[][] backslashCode = new int[N][N];

	boolean[] rowLookup = new boolean[N];
	// arrays to tell us which rows are occupied 
//	boolean[]  = new boolean[N];
	//keep two arrays to tell us which diagonals are occupied 
	boolean[] slashCodeLookup = new boolean[2*N - 1]; 
	boolean[] backslashCodeLookup = new boolean[2*N - 1]; 

	// initialize helper matrices 
	for (int r = 0; r < N; r++) 
		for (int c = 0; c < N; c++) 
			{slashCode[r][c] = r + c;
			backslashCode[r][c] = r - c + (N-1);} 

	if (solveNQueensUtil(board, 0, slashCode, backslashCode, rowLookup, slashCodeLookup, backslashCodeLookup) == false ) 
	{ 
		System.out.println("Solution does not exist"); 
		return false; 
	} 

	// solution found 
	printSolution(board); 
	return true; 
} 

// driver program to test above function 
public static void main(String[] args) {
	nqueen q = new nqueen(32);
	q.solveNQueens(32);
}
}