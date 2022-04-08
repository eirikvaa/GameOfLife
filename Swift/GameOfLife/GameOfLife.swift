//
//  GameOfLife.swift
//  GameOfLife
//
//  Created by Eirik Vale Aase on 02/04/2022.
//

import Foundation

final class GameOfLife: CustomStringConvertible {
    private var size: BoardSize
    private var cells: [[Cell]]

    subscript(coordinate: Coordinate) -> Cell {
        cells[coordinate.y][coordinate.x]
    }

    init(size: BoardSize) {
        self.size = size
        var _cells: [[Cell]] = Array(repeating: [], count: size.width)
        (0 ..< size.height).forEach { y in
            _cells[y] = []
            (0 ..< Int(size.width)).forEach { x in
                _cells[y].append(Cell(coordinate: .init(x: x, y: y)))
            }
        }
        self.cells = _cells
    }

    func simulate(steps: Int) {
        print(self)
        for _ in 0 ..< steps {
            step()
            print(self)
        }
    }

    func simulateForever() {
        print(self)
        while true {
            step()
            print(self)
        }
    }

    /// Simulate by advancing one step at a time simply by tapping enter
    /// or enter some kind of character.
    func simulateWithUserInput() {
        print(self)

        while true {
            let input = readLine()
            if input != nil {
                step()
                print(self)
            }
        }
    }

    private func step() {
        // In the first iteration we only specify what the next state should be
        // If we start updating the states during this iteration, we won't get
        // the result we expect.
        cells.forEach { row in
            row.forEach { cell in
                let neighbours = countNeighbours(base: cell.coordinate)
                let state = cell.state

                switch (neighbours, state) {
                case (0...1, .alive): cell.nextState = .dead
                case (2...3, .alive): break
                case (4..., .alive): cell.nextState = .dead
                case (3, .dead): cell.nextState = .alive
                default: break
                }
            }
        }

        // We're done determining the next states, so actually update them.
        cells.forEach { row in
            row.forEach { cell in
                cell.handleNextState()
            }
        }
    }

    private func countNeighbours(base: Coordinate) -> Int {
        //
        // +-------+------+------+
        // | -1,1  | 0,1  | 1,1  |
        // | -1,0  | 0,0  | 1,0  |
        // | -1,-1 | 0,-1 | 1,-1 |
        // +-------+------+------+
        //
        let deltas: [Delta] = [
            .init(dx: 1, dy: 1),
            .init(dx: -1, dy: -1),
            .init(dx: 1, dy: -1),
            .init(dx: -1, dy: 1),
            .init(dx: 1, dy: 0),
            .init(dx: 0, dy: 1),
            .init(dx: -1, dy: 0),
            .init(dx: 0, dy: -1)
        ]

        return deltas.reduce(0) { result, delta in
            if let neighbour = getNeighbour(delta: delta, base: base) {
                if case .alive = neighbour.state {
                    return result + 1
                } else {
                    return result
                }
            } else {
                return result
            }
        }
    }

    private func getNeighbour(delta: Delta, base: Coordinate) -> Cell? {
        let nextCoordinate = base + delta
        guard isValidCoordinate(coordinate: nextCoordinate) else {
            return nil
        }
        return self[nextCoordinate]
    }

    func setCell(x: Int, y: Int, representation: String) {
        assert(isValidCoordinate(coordinate: .init(x: x, y: y)))

        cells[y][x].representation = representation
    }

    private func isValidCoordinate(coordinate: Coordinate) -> Bool {
        cells.indices.contains(coordinate.y) && cells[coordinate.y].indices.contains(coordinate.x)
    }

    var description: String {
        var output = "|" + String(Array(repeating: "^", count: size.width)) + "|\n"
        for row in cells {
            output += "|"
            for cell in row {
                output += cell.representation
            }
            output += "|\n"
        }
        output += "|" + String(Array(repeating: "^", count: size.width)) + "|\n"
        return output
    }
}
