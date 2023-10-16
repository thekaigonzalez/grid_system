module gol;

import std.stdio : writefln, write, writef;
import std.string : format;
import core.thread : Thread, dur;

const int GRID_SIZE_X = 10;
const int GRID_SIZE_Y = 10;

const char EMPTY = '.';
const char ALIVE = '*';

struct Coordinate
{
    int x;
    int y;
}

struct Grid
{
    char[GRID_SIZE_Y][GRID_SIZE_X] grid;
}

void init_grid(Grid* g)
{
    for (int i = 0; i < GRID_SIZE_Y; i++)
    {
        for (int j = 0; j < GRID_SIZE_X; j++)
        {
            g.grid[i][j] = EMPTY;
        }
    }
}

void print_grid(Grid* g)
{
    for (int i = 0; i < GRID_SIZE_Y; i++)
    {
        for (int j = 0; j < GRID_SIZE_X; j++)
        {
            writef("%c ", g.grid[i][j]);
        }
        writef("\n");
    }
}

bool verify(int x, int y)
{
    return x >= 0 && x < GRID_SIZE_X && y >= 0 && y < GRID_SIZE_Y;
}

void swap(Grid* g, int x, int y, char c)
{
    if (!verify(x, y))
        return;
    g.grid[y][x] = c;
}

bool is_alive(Grid* g, int x, int y)
{
    if (!verify(x, y))
        return false;
    return g.grid[y][x] == ALIVE;
}

void set_alive(Grid* g, int x, int y)
{
    if (!verify(x, y))
        return;
    g.grid[y][x] = ALIVE;
}

bool alive_exists(Grid* g)
{
    for (int i = 0; i < GRID_SIZE_Y; i++)
    {
        for (int j = 0; j < GRID_SIZE_X; j++)
        {
            if (g.grid[i][j] == ALIVE)
            {
                return true;
            }
        }
    }
    return false;
}

void evolve_grid(Grid* current, Grid* next)
{
    for (int y = 0; y < GRID_SIZE_Y; y++)
    {
        for (int x = 0; x < GRID_SIZE_X; x++)
        {
            int aliveNeighbors = 0;

            for (int dy = -1; dy <= 1; dy++)
            {
                for (int dx = -1; dx <= 1; dx++)
                {
                    if (dx == 0 && dy == 0)
                        continue;

                    int nx = x + dx;
                    int ny = y + dy;

                    if (verify(nx, ny) && is_alive(current, nx, ny))
                        aliveNeighbors++;
                }
            }

            if (is_alive(current, x, y))
            {
                // Cell is alive
                if (aliveNeighbors < 2 || aliveNeighbors > 3)
                    set_alive(next, x, y);
            }
            else
            {
                // Cell is dead
                if (aliveNeighbors == 3)
                    set_alive(next, x, y);
            }
        }
    }
}

void clear_screen()
{
    write("\033[2J");
}

void display_grid(Grid* g)
{
    clear_screen();
    print_grid(g);
    Thread.sleep(dur!"seconds"(1));
}

int main()
{
    Grid currentGeneration;
    Grid nextGeneration;

    init_grid(&currentGeneration);
    init_grid(&nextGeneration);

    // Create an initial pattern, for example, a glider:
    set_alive(&currentGeneration, 1, 0);
    set_alive(&currentGeneration, 2, 1);
    set_alive(&currentGeneration, 0, 2);
    set_alive(&currentGeneration, 1, 2);
    set_alive(&currentGeneration, 2, 2);

    while (alive_exists(&currentGeneration))
    {
        display_grid(&currentGeneration);
        evolve_grid(&currentGeneration, &nextGeneration);
        currentGeneration = nextGeneration;
    }

    return 0;
}
