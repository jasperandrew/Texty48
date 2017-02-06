//
//  main.swift
//  Texty48
//
//  Created by Jasper Andrew on 2/2/17.
//  Copyright © 2017 Jasper Andrew. All rights reserved.
//

import Foundation

// The 2D array storing the board's values.
var board = [[0,0,0,0],
             [0,0,0,0],
             [0,0,0,0],
             [0,0,0,0]]

// Keeping track of empty tiles
var empty_tiles = [1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1]
var num_empties = 16

// A dictionary holding the text equivalents of each number
var sym:[Int:String] = [0:" ", 1:"1", 2:"2", 4:"4", 8:"8",
                        16:"A", 32:"B", 64:"C", 128:"D", 256:"E",
                        512:"F", 1024:"G", 2048:"H", 4096:"I", 8192:"J"]

// Prints the board.
func printTheBoard() {
	
	for i in 0..<4 {
		
		print("-----------------")
		for j in 0..<4 {
			let n = board[i][j]
			print("| \(sym[n]!) ",terminator:"")
		}
		print("|")
	}
	print("-----------------")
}

// Checks if a given tile can move in the given direction.
// Returns 0 if not, 1 if yes, and 2 if it can merge with the adjacent tile.
func tileCanMove(row:Int, col:Int, direc:String)->Int {
	
	switch direc {
		
	case "up":
		if row == 0 {return 0}
		if board[row-1][col] == 0 {return 1}
		if board[row-1][col] == board[row][col] {return 2}
		return 0
		
	case "dn":
		if row == 3 {return 0}
		if board[row+1][col] == 0 {return 1}
		if board[row+1][col] == board[row][col] {return 2}
		return 0
		
	case "lt":
		if col == 0 {return 0}
		if board[row][col-1] == 0 {return 1}
		if board[row][col-1] == board[row][col] {return 2}
		return 0
		
	case "rt":
		if col == 3 {return 0}
		if board[row][col+1] == 0 {return 1}
		if board[row][col+1] == board[row][col] {return 2}
		return 0
		
	default:
		exit(1)
	}
}

// Moves or merges a given tile in the given direction.
func moveTile(row:Int, col:Int, direc:String, val:Int) {
	
	switch direc {
		
	case "up":
		board[row-1][col] = val*board[row][col]
		empty_tiles[(row-1)*4+col] = 0
		break
		
	case "dn":
		board[row+1][col] = val*board[row][col]
		empty_tiles[(row+1)*4+col] = 0
		break
		
	case "lt":
		board[row][col-1] = val*board[row][col]
		empty_tiles[row*4+(col-1)] = 0
		break
		
	case "rt":
		board[row][col+1] = val*board[row][col]
		empty_tiles[row*4+(col+1)] = 0
		break
		
	default:
		exit(1)
	}
	
	board[row][col] = 0
	empty_tiles[row*4+col] = 1
}

// Pushes all tiles in a given direction.
func pushTiles(direc:String) {
	
	let uplt = ["up","lt"].contains(direc) ? true : false
	
	var cont = true
	while cont {
		
		cont = false
		var i = uplt ? 0 : 3
		while i != -1 && i != 4 {
			
			var j = uplt ? 0 : 3
			while j != -1 && j != 4 {
				
				if board[i][j] != 0 {
					let canmove = tileCanMove(row: i, col: j, direc: direc)
					if canmove == 1 {
						cont = true
						moveTile(row: i, col: j, direc: direc, val: 1)
					}
					if canmove == 2 {
						cont = true
						moveTile(row: i, col: j, direc: direc, val: 2)
						num_empties += 1
					}
				}
				
				if uplt {j += 1} else {j -= 1}
			}
			
			if uplt {i += 1} else {i -= 1}
		}
	}
}

// Selects a random tile from the set of empty tiles.
func getRandEmptyTile()->Int {
	
	var idx = Int(arc4random_uniform(UInt32(num_empties)))
	for i in 0..<16 {
		
		if(empty_tiles[i] == 1){
			if idx == 0 {return i}
			idx -= 1
		}
	}
	return -1
}

// Inserts a new tile into the board. 
// If no value is given, it will be 1 or 2.
// If no location is given, it will be a random empty location.
func insertTile(val:Int = -1, row:Int = -1, col:Int = -1) {
	
	let value = (val == -1 ? Int(arc4random_uniform(2)+1) : val)
	if row == -1 || col == -1 {
		let loc = getRandEmptyTile()
		if loc == -1 {return}
		
		let c = loc % 4
		let r = (loc - c)/4
		
		board[r][c] = value
		empty_tiles[loc] = 0
		
	} else {
		board[row][col] = value
	}
	
	num_empties -= 1
}

// Print the help message
func printHelp() {
	print("\nControls:")
	print("\t- Enter 'w','a','s','d' to push tiles up, left, down, or right, respectively")
	print("\t- Enter 'q' to quit the game")
	print("\t- Enter 'h' to show this message again\n")
}

// Checks if game is over. 
// Returns result.
func gameIsOver()->Bool {
	return false; // TO-DO
}

// Run the game
func play() {
	print("Welcome to TEXTY48")
	printHelp()
	print("Enjoy!\n")

	insertTile()
	insertTile()
	insertTile()
	printTheBoard()
	
	var exit = 0 // 1 = quit, 2 = gameover
	while exit == 0 {
		let input = readLine()!
		switch input {
		case "w","W":
			pushTiles(direc: "up")
			insertTile()
			break
		case "a","A":
			pushTiles(direc: "lt")
			insertTile()
			break
		case "s","S":
			pushTiles(direc: "dn")
			insertTile()
			break
		case "d","D":
			pushTiles(direc: "rt")
			insertTile()
			break
		case "q","Q":
			print("Are you sure you want to quit? (y/n) ", terminator: "")
			if(["y","Y"].contains(readLine()!)) {exit = 1}
			break
		case "h","H":
			printHelp()
			break
		default:
			print("Invalid input")
		}
		if num_empties == 0 && gameIsOver() {
			exit = 2
		}
		printTheBoard()
	}
	
	
}

play()
