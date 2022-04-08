#include <stdio.h>
#include <string.h>

typedef struct {
    int x;
    int y;
} Coordinate;

typedef struct {
    char *state;
    char *nextState;
    Coordinate coordinate;
} Cell;

typedef struct {
    int dx;
    int dy;
} Delta;

const int boardSize = 10;

// TODO: Shouldn't hardcode the value here.
void setCell(int x, int y, Cell cells[][boardSize], char *state) {
    cells[y][x].state = state;
}

void printBoard(Cell cells[][boardSize]) {
    char output[200] = "|";

    for (int i = 0; i < boardSize; i++) {
        strcat(output, "^");
    }

    strcat(output, "|\n");

    for (int y = 0; y < boardSize; y++) {
        strcat(output, "|");
        for (int x = 0; x < boardSize; x++) {
            Cell cell = cells[y][x];
            strcat(output, cell.state);
        }
        strcat(output, "|\n");
    }

    strcat(output, "|");

    for (int i = 0; i < boardSize; i++) {
        strcat(output, "^");
    }

    strcat(output, "|\n");

    printf("%s", output);
}

Cell *getNeighbour(Cell cells[][boardSize], Delta delta, Coordinate base) {
    Coordinate nextCoordinate = {
            .x = delta.dx + base.x,
            .y = delta.dy + base.y
    };
    int validX = nextCoordinate.x >= 0 && nextCoordinate.x < boardSize;
    int validY = nextCoordinate.y >= 0 && nextCoordinate.y < boardSize;

    if (validX && validY) {
        return &cells[nextCoordinate.y][nextCoordinate.x];
    } else {
        return NULL;
    }
}

int countNeighbours(Cell cells[][boardSize], Coordinate base) {
    Delta deltas[8] = {
            {.dx = 1, .dy = 1},
            {.dx = -1, .dy = -1},
            {.dx = 1, .dy = -1},
            {.dx = -1, .dy = 1},
            {.dx = 1, .dy = 0},
            {.dx = 0, .dy = 1},
            {.dx = -1, .dy = 0},
            {.dx = 0, .dy = -1}
    };

    int neighbours = 0;
    for (int i = 0; i < 8; i++) {
        Cell *cell = getNeighbour(cells, deltas[i], base);

        if (cell != NULL) {
            Cell actualCell = *cell;
            if (strcmp(actualCell.state, "x") == 0) {
                neighbours++;
            }
        }
    }

    return neighbours;
}

void step(Cell cells[][boardSize]) {
    for (int y = 0; y < boardSize; y++) {
        for (int x = 0; x < boardSize; x++) {
            Cell cell = cells[y][x];
            int neighbours = countNeighbours(cells, cell.coordinate);

            if (strcmp(cell.state, "x") == 0) {
                if (neighbours <= 1) {
                    cell.nextState = "_";
                } else if (neighbours == 2 || neighbours == 3) {
                    cell.nextState = cell.state;
                } else if (neighbours >= 4) {
                    cell.nextState = "_";
                }
            } else if (strcmp(cell.state, "_") == 0) {
                if (neighbours == 3) {
                    cell.nextState = "x";
                }
            }

            cells[y][x] = cell;
        }
    }

    for (int y = 0; y < boardSize; y++) {
        for (int x = 0; x < boardSize; x++) {
            Cell cell = cells[y][x];
            if (cell.nextState != NULL) {
                cell.state = cell.nextState;
            }
            cells[y][x] = cell;
        }
    }
}

void simulate(Cell cells[][boardSize], int steps) {
    printBoard(cells);

    for (int i = 0; i < steps; i++) {
        step(cells);
        printBoard(cells);
    }
}

int main() {
    Cell cells[boardSize][boardSize];

    for (int y = 0; y < boardSize; y++) {
        for (int x = 0; x < boardSize; x++) {
            Coordinate coordinate = {
                    .x = x,
                    .y = y
            };
            Cell cell = {
                    .state = "_",
                    .nextState = NULL,
                    .coordinate = coordinate
            };
            cells[y][x] = cell;
        }
    }

    setCell(4, 3, cells, "x");
    setCell(3, 4, cells, "x");
    setCell(4, 4, cells, "x");
    setCell(5, 4, cells, "x");
    setCell(3, 5, cells, "x");
    setCell(4, 5, cells, "x");
    setCell(5, 5, cells, "x");

    simulate(cells, 10);

    return 0;
}