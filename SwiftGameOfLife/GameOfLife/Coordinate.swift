//
//  Coordinate.swift
//  GameOfLife
//
//  Created by Eirik Vale Aase on 02/04/2022.
//

struct Coordinate {
    let x, y: Int

    static func + (lhs: Coordinate, delta: Delta) -> Coordinate {
        Coordinate(x: lhs.x + delta.dx, y: lhs.y + delta.dy)
    }
}
