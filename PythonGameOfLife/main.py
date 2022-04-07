from GameOfLife import GameOfLife, BoardSize


def main():
    gol = GameOfLife(size=BoardSize(width=10, height=10))
    gol.set_cell(x=4, y=3, representation="x")
    gol.set_cell(x=3, y=4, representation="x")
    gol.set_cell(x=4, y=4, representation="x")
    gol.set_cell(x=5, y=4, representation="x")
    gol.set_cell(x=3, y=5, representation="x")
    gol.set_cell(x=4, y=5, representation="x")
    gol.set_cell(x=5, y=5, representation="x")
    gol.simulate_with_user_input()


if __name__ == '__main__':
    main()
