from CellState import CellState
from Coordinate import Coordinate


class Cell:
    def __init__(self, coordinate: Coordinate):
        self.coordinate = coordinate
        self.representation = "_"
        # TODO: Look into modelling this as an optional property.
        self.nextState = CellState.DEAD

    def get_state(self):
        if self.representation == "_":
            return CellState.DEAD
        elif self.representation == "x":
            return CellState.ALIVE
        else:
            raise ValueError("Unsupported representation.")

    def kill(self):
        self.representation = "_"

    def birth(self):
        self.representation = "x"

    def handle_next_state(self):
        if self.nextState is CellState.ALIVE:
            self.birth()
        elif self.nextState is CellState.DEAD:
            self.kill()
        else:
            raise ValueError("Unsupported state.")

    def __repr__(self):
        return self.representation
