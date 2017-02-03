//
//  main.swift
//  Texty48
//
//  Created by Jasper Andrew on 2/2/17.
//  Copyright © 2017 Jasper Andrew. All rights reserved.
//

import Foundation
let DBG = true

var board = [[1,2,0,0],
             [0,2,0,0],
             [0,0,0,0],
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

func canMove(r:Int, c:Int, dir:String)->Bool {
	switch dir {
	case "up":
		if r == 0 {return false}
		if board[r-1][c] == 0 {return true}
		return false
	case "dn":
		if r == 3 {return false}
		if board[r+1][c] == 0 {return true}
		return false
	case "lt":
		if c == 0 {return false}
		if board[r][c-1] == 0 {return true}
		return false
	case "rt":
		if c == 3 {return false}
		if board[r][c+1] == 0 {return true}
		return false
	default:
		exit(1)
	}
}

func push(dir:String) {
	var cont = true
	while cont {
		cont = false
		for i in 0..<4 {
			for j in 0..<4 {
				if board[i][j] != 0 && canMove(r: i, c: j, dir: dir) {
					if DBG { print("pushing (\(i),\(j)) \(dir)") }
					cont = true
					switch dir {
					case "up":
						board[i-1][j] = board[i][j]; break
					case "dn":
						board[i+1][j] = board[i][j]; break
					case "lt":
						board[i][j-1] = board[i][j]; break
					case "rt":
						board[i][j+1] = board[i][j]; break
					default:
						exit(1)
					}
					board[i][j] = 0
				}
			}
		}
	}
}

printTheBoard()
push(dir: "rt")
printTheBoard()
push(dir: "dn")
printTheBoard()
push(dir: "lt")
printTheBoard()
push(dir: "up")
printTheBoard()
