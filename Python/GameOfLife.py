from enum import Enum
from typing import Optional

from BoardSize import BoardSize
from Cell import Cell
from CellState import CellState
from Coordinate import Coordinate, add
from Delta import Delta


class GameOfLife:
    def __init__(self, size: BoardSize):
        self.size = size
        _cells = [[] for _ in range(size.width)]
        for y in range(size.height):
            _cells[y] = []
            for x in range(size.width):
                _cells[y].append(Cell(coordinate=Coordinate(x=x, y=y)))
        self.cells: [[Cell]] = _cells

    def simulate(self, steps: int):
        print(self)
        for _ in range(steps):
            self.step()
            print(self)

    def simulate_forever(self):
        print(self)
        while True:
            self.step()
            print(self)

    def simulate_with_user_input(self):
        print(self)
        while True:
            user_input = input()
            if user_input is not None:
                self.step()
                print(self)

    def step(self):
        for row in self.cells:
            for cell in row:
                neighbours = self.count_neighbours(base=cell.coordinate)
                state: CellState = cell.get_state()

                if state is CellState.ALIVE:
                    if neighbours <= 1:
                        cell.nextState = CellState.DEAD
                    elif 2 <= neighbours <= 3:
                        cell.nextState = cell.get_state()
                    elif neighbours >= 4:
                        cell.nextState = CellState.DEAD
                elif state is CellState.DEAD:
                    if neighbours == 3:
                        cell.nextState = CellState.ALIVE

        # We're done determining the next states, so actually update them.
        for row in self.cells:
            for cell in row:
                cell.handle_next_state()

    def count_neighbours(self, base) -> int:
        deltas: [Delta] = [
            Delta(dx=1, dy=1),
            Delta(dx=-1, dy=-1),
            Delta(dx=1, dy=-1),
            Delta(dx=-1, dy=1),
            Delta(dx=1, dy=0),
            Delta(dx=0, dy=1),
            Delta(dx=-1, dy=0),
            Delta(dx=0, dy=-1)
        ]

        neighbours = 0
        for delta in deltas:
            neighbour: Cell = self.get_neighbour(delta=delta, base=base)
            if neighbour is not None:
                if neighbour.get_state() is CellState.ALIVE:
                    neighbours += 1

        return neighbours

    def get_neighbour(self, delta: Delta, base: Coordinate) -> Optional[Cell]:
        next_coordinate = add(coordinate=base, delta=delta)
        if self.is_valid_coordinate(coordinate=next_coordinate):
            return self.cells[next_coordinate.y][next_coordinate.x]
        else:
            return None

    def set_cell(self, x: int, y: int, representation: str):
        self.cells[y][x].representation = representation

    def is_valid_coordinate(self, coordinate) -> bool:
        return coordinate.x in range(0, self.size.width) and coordinate.y in range(0, self.size.height)

    def __repr__(self):
        output = "|" + "^" * self.size.width + "|\n"
        for row in self.cells:
            output += "|"
            for cell in row:
                output += cell.representation
            output += "|\n"
        output += "|" + "^" * self.size.width + "|\n"
        return output
