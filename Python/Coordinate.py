from Delta import Delta


class Coordinate:
    def __init__(self, x: int, y: int):
        self.x = x
        self.y = y

    def __repr__(self):
        return f"({self.x},{self.y})"


# TODO: Figure out how to define this method in the Coordinate class.
def add(coordinate: Coordinate, delta: Delta):
    return Coordinate(coordinate.x + delta.dx, coordinate.y + delta.dy)
