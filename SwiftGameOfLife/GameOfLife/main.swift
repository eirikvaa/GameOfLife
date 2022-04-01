//
//  main.swift
//  GameOfLife
//
//  Created by Eirik Vale Aase on 01/04/2022.
//

import Foundation

let gol = GameOfLife(size: .init(size: 10))
gol.setCell(x: 4, y: 3, representation: "x")
gol.setCell(x: 3, y: 4, representation: "x")
gol.setCell(x: 4, y: 4, representation: "x")
gol.setCell(x: 5, y: 4, representation: "x")
gol.setCell(x: 3, y: 5, representation: "x")
gol.setCell(x: 4, y: 5, representation: "x")
gol.setCell(x: 5, y: 5, representation: "x")
gol.simulateWithUserInput()
