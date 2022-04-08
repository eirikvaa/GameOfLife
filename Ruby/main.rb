class Delta
    def initialize(dx, dy)
        @dx = dx
        @dy = dy
    end

    def dx
        @dx
    end

    def dy
        @dy
    end
end

class Coordinate
    def initialize(x, y)
        @x = x
        @y = y
    end

    def x
        @x
    end

    def y
        @y
    end
end

class Cell
    def initialize(state = "_", nextState = "_", coordinate)
        @state = state
        @nextState = nextState
        @coordinate = coordinate
    end

    def state
        @state
    end

    def state=(state)
        @state = state
    end

    def nextState
        @nextState
    end

    def nextState=(nextState)
        @nextState = nextState
    end

    def coordinate
        @coordinate
    end

    def handleNextState
        @state = @nextState
    end

    def to_s
        @state
    end
end

class GameOfLife
    def initialize(boardSize)
        @boardSize = boardSize
        @cells = []

        (0...boardSize).each do |y|
            @cells.push([])
            (0...boardSize).each do |x|
                cell = Cell.new(Coordinate.new(x, y))
                @cells[y].push(cell)
            end
        end
    end

    def setCell(x, y, state)
        @cells[y][x].state = state
    end

    def simulateWithSteps(steps)
        puts self

        (0...steps).each do |s|
            step
            puts self
        end
    end

    def step
        @cells.each do |row|
            row.each do |cell|
                neighbours = countNeighbours(cell.coordinate)
                state = cell.state

                if (state == "x")
                    if (neighbours <= 1) 
                        cell.nextState = "_"
                    elsif (neighbours == 2 || neighbours == 3)
                        cell.nextState = cell.state
                    elsif (neighbours >= 4)
                        cell.nextState = "_"
                    end
                elsif (state == "_")
                    if (neighbours == 3)
                        cell.nextState = "x"
                    end
                end
            end
        end

        @cells.each do |row|
            row.each do |cell|
                cell.handleNextState
            end
        end
    end

    def countNeighbours(base)
        deltas = [
            Delta.new(1, 1),
            Delta.new(-1, -1),
            Delta.new(1, -1),
            Delta.new(-1, 1),
            Delta.new(1, 0),
            Delta.new(0, 1),
            Delta.new(-1, 0),
            Delta.new(0, -1)
        ]

        neighbours = 0
        deltas.each do |delta|
            neighbour = getNeighbour(delta, base)
            if (neighbour != nil) 
                if (neighbour.state == "x")
                    neighbours += 1
                end
            end
        end

        return neighbours
    end

    def getNeighbour(delta, base)
        nextCoordinate = Coordinate.new(delta.dx + base.x, delta.dy + base.y)

        validX = (0 ... @boardSize).include?(nextCoordinate.x)
        validY = (0 ... @boardSize).include?(nextCoordinate.y)
        if (validX && validY)
            @cells[nextCoordinate.y][nextCoordinate.x]
        else
            nil
        end
    end

    def to_s
        # Not 100% why I need to increment @boardSize with 1 to
        # make it align with the other rows.
        output = "|" + "^" * @boardSize + "|\n"
        @cells.each do |row|
            output += "|"
            row.each do |cell|
                output += cell.state
            end
            output += "|\n"
        end
        output += "|" + "^" * @boardSize + "|\n"
        output
    end
end

def main
    gol = GameOfLife.new(10)
    gol.setCell(4, 3, "x")
    gol.setCell(3, 4, "x")
    gol.setCell(4, 4, "x")
    gol.setCell(5, 4, "x")
    gol.setCell(3, 5, "x")
    gol.setCell(4, 5, "x")
    gol.setCell(5, 5, "x")
    
    gol.simulateWithSteps(10)
end

main
