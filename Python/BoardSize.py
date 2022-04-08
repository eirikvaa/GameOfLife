class BoardSize:
    def __init__(self, width: int, height: int):
        self.width = width
        self.height = height

    @classmethod
    def with_width_and_height(cls, width: int, height: int):
        cls(width=width, height=height)

    @classmethod
    def width_size(cls, size: int):
        cls(width=size, height=size)
