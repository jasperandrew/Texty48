// Texty48 (C++)
//
// Copyright © 2018 Jasper Andrew. All rights reserved.

using namespace std;

#include <iostream>
#include <vector>
#include <map>
#include <stdlib.h>
#include <string>

// The 2D array storing the board's values.
vector<vector<int> > board(4, vector<int>(4));

// Keeping track of empty tiles
vector<int> empty_tiles = {1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1};
int num_empties = 16;

// A dictionary holding the text equivalents of each number
map<int, char> sym = {{0,' '}, {1,'1'}, {2,'2'}, {3,'3'}, {4,'4'}, {8,'8'}, {16,'A'}, {32,'B'}, {64,'C'}, {128,'D'}, {256,'E'}, {512,'F'}, {1024,'G'}, {2048,'H'}, {4098,'I'}, {8192,'J'}};

// Prints the board.
void printTheBoard() {
    for(int i = 0; i < 10; i++) cout << "\033[1A\033[K";

    for(int i = 0; i < 4; i++){
        cout << "-----------------" << endl;
        for(int j = 0; j < 4; j++){
            int n = board[i][j];
            cout << "| " << sym[n] << " ";
        }
        cout << "|" << endl;
    }
    cout << "-----------------" << endl;
}

// Checks if a given tile can move in the given direction.
// Returns 0 if not, 1 if yes, and 2 if it can merge with the adjacent tile.
int tileCanMove(int row, int col, char direc) {
    switch(direc){
    case 'u':
        if(row == 0) return 0;
        if(board[row-1][col] == 0) return 1;
        if(board[row-1][col] == board[row][col]) return 2;
		return 0;
    case 'd':
        if(row == 3) return 0;
        if(board[row+1][col] == 0) return 1;
        if(board[row+1][col] == board[row][col]) return 2;
		return 0;
    case 'l':
        if(col == 0) return 0;
        if(board[row][col-1] == 0) return 1;
        if(board[row][col-1] == board[row][col]) return 2;
		return 0;
    case 'r':
        if(col == 3) return 0;
        if(board[row][col+1] == 0) return 1;
        if(board[row][col+1] == board[row][col]) return 2;
		return 0;
    default:
        exit(1);
    }
}

// Moves or merges a given tile in the given direction.
void moveTile(int row, int col, char direc, int val) {
    switch(direc){	
    case 'u':
		board[row-1][col] = val*board[row][col];
		empty_tiles[(row-1)*4+col] = 0;
		break;
    case 'd':
		board[row+1][col] = val*board[row][col];
		empty_tiles[(row+1)*4+col] = 0;
		break;
    case 'l':
		board[row][col-1] = val*board[row][col];
		empty_tiles[row*4+(col-1)] = 0;
		break;
    case 'r':
		board[row][col+1] = val*board[row][col];
		empty_tiles[row*4+(col+1)] = 0;
		break;
	default:
		exit(1);
	}
	
	board[row][col] = 0;
	empty_tiles[row*4+col] = 1;
}

// Pushes all tiles in a given direction.
int pushTiles(char direc) {
    int moved = 0;
    int ul = (direc == 'u' || direc == 'l') ? 1 : 0;

    int cont = 1;
    while(cont){
        cont = 0;

        int i = ul ? 0 : 3;
        while(i != -1 && i != 4){

            int j = ul ? 0 : 3;
            while(j != -1 && j != 4){

                if(board[i][j] != 0){
                    int canmove = tileCanMove(i, j, direc);
                    if(canmove == 1){
                        cont = 1;
                        moveTile(i, j, direc, 1);
                        moved = 1;
                    }
                    if(canmove == 2){
                        cont = 1;
                        moveTile(i, j, direc, 2);
                        num_empties += 1;
                        moved = 1;
                    }
                }

                if(ul) j += 1;
                else j -= 1;
            }

            if(ul) i += 1;
            else i -= 1;
        }
    }
    return moved;
}

// Selects a random tile from the set of empty tiles.
int getRandEmptyTile() {
    int idx = rand() % num_empties;
    for(int i = 0; i < 16; i++){
        if(empty_tiles[i] == 1){
            if(idx == 0) return i;
            idx -= 1;
        }
    }
    return -1;
}

// Inserts a new tile into the board. 
// If no value is given, it will be 1 or 2.
// If no location is given, it will be a random empty location.
void insertTile(int val = -1, int row = -1, int col = -1) {
    int value = (val == -1 ? rand() % 2 + 1 : val);
    if(row == -1 || col == -1) {
        int loc = getRandEmptyTile();
        if(loc == -1) return;

        int c = loc % 4;
        int r = (loc - c)/4;

        board[r][c] = value;
        empty_tiles[loc] = 0;
    }else{
        board[row][col] = value;
    }
    num_empties -= 1;
}

// Checks if game is over. 
// Returns result.
int gameIsOver() {
	return 0; // TO-DO
}

// Run the game
int main() {
    srand(time(NULL));

    cout << "Welcome to TEXTY48" << endl;
	cout << "\nControls:" << endl;
	cout << "   - Enter 'w','a','s','d' to push tiles up, left, down, or right, respectively" << endl;
	cout << "       (Note: Only the first character entered on a line will register)" << endl;
	cout << "   - Enter 'q' to quit the game" << endl;
	cout << "Enjoy!\n" << endl;

	insertTile();
	insertTile();
	insertTile();
    for(int i = 0; i < 10; i++) cout << endl;
	printTheBoard();

	int exit = 0; // 1 = quit, 2 = gameover
	while(exit == 0){
		string input;
        cin >> input;
        char c = input[0];
		switch(c){
		case 'w':
        case 'W':
			if(pushTiles('u')) insertTile();
			break;
        case 'a':
        case 'A':
			if(pushTiles('l')) insertTile();
			break;
		case 's':
        case 'S':
			if(pushTiles('d')) insertTile();
			break;
		case 'd':
        case 'D':
			if(pushTiles('r')) insertTile();
			break;
		case 'q':
        case 'Q':
            cout << "\033[1A\033[K";
			cout << "Are you sure you want to quit? (y/n) ";
            cin >> input;
            c = input[0];
			if(c == 'y' || c == 'Y') exit = 1;
			break;
		default:
            break;
		}

		if(num_empties == 0 && gameIsOver()) exit = 2;

		printTheBoard();
	}
}