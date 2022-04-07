fun main(args: Array<String>) {
    val gol = GameOfLife(10)

    gol.setCell(4, 3, "x")
    gol.setCell(3, 4, "x")
    gol.setCell(4, 4, "x")
    gol.setCell(5, 4, "x")
    gol.setCell(3, 5, "x")
    gol.setCell(4, 5, "x")
    gol.setCell(5, 5, "x")
    gol.simulateWithSteps(10)
}

class GameOfLife(private val boardSize: Int) {
    private val cells: MutableList<MutableList<Cell>> = mutableListOf()

    init {
        for (y in 0 until boardSize) {
            cells.add(mutableListOf())
            for (x in 0 until boardSize) {
                cells[y].add(
                    Cell(coordinate = Coordinate(x = x, y = y), state = "_")
                )
            }
        }
    }

    fun simulateWithSteps(steps: Int) {
        println(this)

        for (step in 0..steps) {
            step()
            println(this)
        }
    }

    private fun step() {
        cells.forEach { row ->
            row.forEach { cell ->
                val neighbours = countNeighbours(base = cell.coordinate)
                val state = cell.state

                if (state == "x") {
                    if (neighbours <= 1) {
                        cell.nextState = "_"
                    } else if ((2..3).contains(neighbours)) {
                        cell.nextState = cell.state
                    } else if (neighbours >= 4) {
                        cell.nextState = "_"
                    }
                } else if (state == "_") {
                    if (neighbours == 3) {
                        cell.nextState = "x"
                    }
                }
            }
        }

        cells.forEach { row ->
            row.forEach { cell ->
                cell.handleNextState()
            }
        }
    }

    private fun countNeighbours(base: Coordinate): Int {
        val deltas = listOf(
            Delta(1, 1),
            Delta(-1, -1),
            Delta(1, -1),
            Delta(-1, 1),
            Delta(1, 0),
            Delta(0, 1),
            Delta(-1, 0),
            Delta(0, -1)
        )

        var neighbours = 0
        deltas.forEach {
            val neighbour = getNeighbour(it, base)
            if (neighbour?.state == "x") {
                neighbours += 1
            }
        }

        return neighbours
    }

    private fun getNeighbour(delta: Delta, base: Coordinate): Cell? {
        val nextCoordinate = Coordinate(x = delta.dx + base.x, y = delta.dy + base.y)
        return if ((0 until boardSize).contains(nextCoordinate.x) && (0 until boardSize).contains(nextCoordinate.y)) {
            cells[nextCoordinate.y][nextCoordinate.x]
        } else {
            null
        }
    }

    fun setCell(x: Int, y: Int, state: String) {
        cells[y][x].state = state
    }

    override fun toString(): String {
        var output = "|" + "^".repeat(boardSize) + "|\n"
        cells.forEach { row ->
            output += "|"
            row.forEach { cell ->
                output += cell.state
            }
            output += "|\n"
        }
        output += "|" + "^".repeat(boardSize) + "|\n"
        return output
    }
}

class Cell(val coordinate: Coordinate, var state: String, var nextState: String? = null) {
    fun handleNextState() = nextState?.let {
        state = it
    }
}

data class Coordinate(val x: Int, val y: Int)

data class Delta(val dx: Int, val dy: Int)