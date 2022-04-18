import strings

const (
	board_size = 10
)

struct Delta {
	dx int
	dy int
}

struct Coordinate {
	x int
	y int
}

struct Cell {
mut:
	coordinate Coordinate
	state      string = '_'
	next_state string
}

pub fn (mut c Cell) handle_next_state() {
	c.state = c.next_state
}

pub fn (c Cell) str() string {
	return c.state
}

struct GameOfLife {
mut:
	cells [][]Cell [required]
}

// V doesn't have classes, just structs that hold data. You need
// to declare methods in the same module as the struct that accept
// a parameter of that struct if you want to define methods on the
// type.
fn (mut g GameOfLife) init() {
	for y in 0 .. board_size {
		// For-in, exlcusive upper limit
		for x in 0 .. board_size {
			g.cells[y][x] = Cell{
				coordinate: Coordinate{
					x: x
					y: y
				}
				state: '_'
				next_state: '_'
			}
		}
	}
}

pub fn (mut g GameOfLife) set_cell(x int, y int, state string) {
	g.cells[y][x].state = state
}

pub fn (mut g GameOfLife) simulate_with_steps(steps int) {
	println(g)

	for _ in 0 .. steps {
		g.step()
		println(g)
	}
}

pub fn (mut g GameOfLife) step() {
	for y in 0 .. board_size {
		for x in 0 .. board_size {
			neighbours := g.count_neighbours(g.cells[y][x].coordinate)
			state := g.cells[y][x].state

			if state == 'x' {
				if neighbours <= 1 {
					g.cells[y][x].next_state = '_'
				} else if neighbours == 2 || neighbours == 3 {
					g.cells[y][x].next_state = g.cells[y][x].state
				} else if neighbours >= 4 {
					g.cells[y][x].next_state = '_'
				}
			} else if state == '_' {
				if neighbours == 3 {
					g.cells[y][x].next_state = 'x'
				}
			}
		}
	}

	for y in 0 .. board_size {
		for x in 0 .. board_size {
			g.cells[y][x].handle_next_state()
		}
	}
}

pub fn (g GameOfLife) count_neighbours(base Coordinate) int {
	deltas := [
		Delta{1, 1},
		Delta{-1, -1},
		Delta{1, -1},
		Delta{-1, 1},
		Delta{1, 0},
		Delta{0, 1},
		Delta{-1, 0},
		Delta{0, -1},
	]

	mut neighbours := 0
	for delta in deltas {
		neighbour := g.get_neighbour(delta, base) or { continue }
		if neighbour.state == 'x' {
			neighbours += 1
		}
	}

	return neighbours
}

pub fn (g GameOfLife) get_neighbour(delta Delta, base Coordinate) ?Cell {
	next_coordinate := Coordinate{delta.dx + base.x, delta.dy + base.y}
	if next_coordinate.x < board_size && next_coordinate.x >= 0 && next_coordinate.y < board_size
		&& next_coordinate.y >= 0 {
		return g.cells[next_coordinate.y][next_coordinate.x]
	} else {
		return error('Invalid coordinate.')
	}
}

pub fn (g GameOfLife) str() string {
	mut output := '|' + strings.repeat(`^`, board_size) + '|\n'

	for row in g.cells {
		output += '|'
		for cell in row {
			output += cell.state
		}
		output += '|\n'
	}

	output += '|' + strings.repeat(`^`, board_size) + '|\n'

	return output
}

fn main() {
	mut gol := GameOfLife{
		cells: [][]Cell{len: board_size, init: []Cell{len: board_size}}
	}
	gol.init()
	gol.set_cell(4, 3, 'x')
	gol.set_cell(3, 4, 'x')
	gol.set_cell(4, 4, 'x')
	gol.set_cell(5, 4, 'x')
	gol.set_cell(3, 5, 'x')
	gol.set_cell(4, 5, 'x')
	gol.set_cell(5, 5, 'x')
	gol.simulate_with_steps(10)
}
