//
//  main.swift
//  Texty48
//
//  Created by Jasper Andrew on 2/2/17.
//  Copyright © 2017 Jasper Andrew. All rights reserved.
//

import Foundation
let DBG = false

var board = [[1,2,0,0],
             [0,2,0,0],
             [0,0,2,0],
             [0,0,0,0]]

var sym:[Int:String] = [0:" ", 1:"1", 2:"2", 4:"4", 8:"8",
                        16:"A", 32:"B", 64:"C", 128:"D", 256:"E",
                        512:"F", 1024:"G", 2048:"H", 4096:"I", 8192:"J"]

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

func moveTile(row:Int, col:Int, direc:String, val:Int) {
	switch direc {
	case "up":
		board[row-1][col] = val*board[row][col]; break
	case "dn":
		board[row+1][col] = val*board[row][col]; break
	case "lt":
		board[row][col-1] = val*board[row][col]; break
	case "rt":
		board[row][col+1] = val*board[row][col]; break
	default:
		exit(1)
	}
	board[row][col] = 0
}

func push(direc:String) {
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
					}
				}
				
				if uplt {j += 1} else {j -= 1}
			}
			
			if uplt {i += 1} else {i -= 1}
		}
	}
}

func emptySquares() -> Int {
	return 0
}

board = [[1,2,4,0],
		 [1,2,4,0],
		 [1,2,4,0],
		 [0,0,0,0]]
printTheBoard()
push(direc: "up")
printTheBoard()
print()

board = [[1,1,1,0],
         [2,2,2,0],
         [4,4,4,0],
         [0,0,0,0]]
printTheBoard()
push(direc: "lt")
printTheBoard()
print()

board = [[1,2,4,0],
         [1,2,4,0],
         [1,2,4,0],
         [0,0,0,0]]
printTheBoard()
push(direc: "dn")
printTheBoard()
print()

board = [[1,1,1,0],
         [2,2,2,0],
         [4,4,4,0],
         [0,0,0,0]]
printTheBoard()
push(direc: "rt")
printTheBoard()
