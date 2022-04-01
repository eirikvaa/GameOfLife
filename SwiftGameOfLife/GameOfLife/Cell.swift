//
//  Cell.swift
//  GameOfLife
//
//  Created by Eirik Vale Aase on 02/04/2022.
//

final class Cell {
    enum State {
        case dead
        case alive
    }

    var coordinate: Coordinate
    var representation: String = "_"
    var nextState: State?

    init(coordinate: Coordinate) {
        self.coordinate = coordinate
    }

    var state: State {
        switch representation {
        case "_": return .dead
        case "x": return .alive
        default: fatalError("Unsupported representation.")
        }
    }

    func kill() {
        representation = "_"
    }

    func birth() {
        representation = "x"
    }

    func handleNextState() {
        switch nextState {
        case .alive?:
            representation = "x"
        case .dead?:
            representation = "_"
        default:
            break
        }
    }
}
