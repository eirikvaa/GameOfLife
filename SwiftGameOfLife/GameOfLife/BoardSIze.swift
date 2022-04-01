//
//  BoardSIze.swift
//  GameOfLife
//
//  Created by Eirik Vale Aase on 02/04/2022.
//

struct BoardSize {
    let width: Int
    let height: Int

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    init(size: Int) {
        self.width = size
        self.height = size
    }
}
