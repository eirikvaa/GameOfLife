class Cell {
    constructor(coordinate) {
        this.state = "_"
        this.nextState = null
        this.coordinate = coordinate
    }
}

function main() {
    const boardSize = 10

    // Initialize cells of board.
    var cells = []
    for (let y = 0; y < boardSize; y++) {
        cells.push([])

        for (let x = 0; x < boardSize; x++) {
            cells[y].push(new Cell({ x: x, y: y }));
        }
    }

    // Create the initial pattern.
    setCell(4, 3, cells, "x");
    setCell(3, 4, cells, "x"); setCell(4, 4, cells, "x"); setCell(5, 4, cells, "x");
    setCell(3, 5, cells, "x"); setCell(4, 5, cells, "x"); setCell(5, 5, cells, "x");

    simulate(cells, 10, boardSize)
}

// TODO: Implement simulate with user input.

function simulate(cells, steps, size) {
    printBoard(cells)

    for (let i = 0; i < steps; i++) {
        step(cells, size)

        printBoard(cells)
    }
}

function simulateForever(cells, size) {
    printBoard(cells)

    while (true) {
        step(cells, size)

        printBoard(cells)
    }
}

function step(cells, size) {
    cells.forEach(row => {
        row.forEach(cell => {
            let neighbours = countNeighbours(cells, cell.coordinate, size)
            let state = cell.state

            if (state == "x") {
                if (neighbours <= 1) {
                    cell.nextState = "_"
                } else if (neighbours >= 2 && neighbours <= 3) {
                    // Feels wrong...
                    cell.state = cell.state
                } else if (neighbours >= 4) {
                    cell.nextState = "_"
                }
            } else if (state == "_") {
                if (neighbours == 3) {
                    cell.nextState = "x"
                }
            }
        })
    })

    cells.forEach(row => {
        row.forEach(cell => {
            if (cell.nextState != null) {
                switch (cell.nextState) {
                    case "x":
                        cell.state = "x"
                        break
                    case "_":
                        cell.state = "_"
                        break
                }
            }
        })
    })
}

function countNeighbours(cells, base, size) {
    let deltas = [
        { x: 1, y: 1 },
        { x: -1, y: -1 },
        { x: 1, y: -1 },
        { x: -1, y: 1 },
        { x: 1, y: 0 },
        { x: 0, y: 1 },
        { x: -1, y: 0 },
        { x: 0, y: -1 }
    ]

    let neighbours = 0
    deltas.forEach(delta => {
        let neighbour = getNeighbour(cells, delta, base, size)
        if (neighbour != null) {
            if (neighbour.state == "x") {
                neighbours += 1
            }
        }
    })

    return neighbours
}

function getNeighbour(cells, delta, base, size) {
    let nextCoordinate = { x: delta.x + base.x, y: delta.y + base.y }
    if (isValidCoordinate(nextCoordinate, size)) {
        return cells[nextCoordinate.y][nextCoordinate.x]
    } else {
        return null
    }
}

function isValidCoordinate(coordinate, size) {
    return (coordinate.x >= 0 && coordinate.x < size) && (coordinate.y >= 0 && coordinate.y < size)
}

function printBoard(cells) {
    cells.forEach(row => {
        console.log(row.map(cell => cell.state).join());
    })
    console.log("")
}

function setCell(x, y, cells, representation) {
    cells[y][x].state = representation
}

main()
