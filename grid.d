/*Copyright 2019-2023 Kai D. Gonzalez*/

import std.stdio : writefln, write, writef;
import std.string : format;
import core.thread : Thread, dur;

// setting default grid size
const int GRID_SIZE_X = 5;
const int GRID_SIZE_Y = 5;

// simple constant entities
const char EMPTY = '.';
const char ALIVE = '*';

// a 'coordinate' is a position on the grid
// this is separate from ACTUAL points on the grid, which are physical points
// inside the 2D integer array
struct Coordinate
{
    int x;
    int y;
}

// holds a 2D character array
struct Grid
{
    char[GRID_SIZE_Y][GRID_SIZE_X] grid;
}

// initializes the grid, setting all cells to EMPTY
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

// returns true if a point is not out of bounds
bool verify(int x, int y)
{
    return x >= 0 && x < GRID_SIZE_X && y >= 0 && y < GRID_SIZE_Y;
}

// sets a point to a character, to check if it is valid use set_alive() or is_occupied()
void swap(Grid* g, int x, int y, char c)
{
    if (!verify(x, y))
        return;
    g.grid[y][x] = c;
}

// returns true if a point is occupied
bool is_occupied(Grid* g, int x, int y)
{
    if (!verify(x, y))
        return false;
    return g.grid[y][x] != EMPTY;
}

Coordinate set_alive(Grid* g, int x, int y)
{
    if (!verify(x, y) || alive_exists(g))
        return failed_coordinate();
    g.grid[y][x] = ALIVE;
    return create_coordinate(x, y);
}

void search_and_print_grid(Grid* g)
{
    for (int i = 0; i < GRID_SIZE_Y; i++)
    {
        for (int j = 0; j < GRID_SIZE_X; j++)
        {
            switch (g.grid[i][j])
            {
            case ALIVE:
                writefln("(%d, %d): point is alive", i, j);
                break;
            case EMPTY:
                break;
            default:
                writefln("(%d, %d): point is another type (the empty symbol is '%c')", i, j, EMPTY);
                break;
            }
        }
    }
}

// returns true if the sides of a specified area are available
bool sides_are_available(Grid* g, int x, int y)
{
    if (!verify(x, y))
        return false;

    if (g.grid[y][x] == ALIVE)
    {
        if (g.grid[y - 1][x] != EMPTY || g.grid[y + 1][x] != EMPTY ||
            g.grid[y][x - 1] != EMPTY || g.grid[y][x + 1] != EMPTY)
        {
            return false;
        }
    }
    return true;
}

// creates a failed coordinate, used for errors
// this coordinate goes out of the bounds of the grid
Coordinate failed_coordinate()
{
    Coordinate c;
    c.x = -1;
    c.y = -1;
    return c;
}

// creates a coordinate from x and y
Coordinate create_coordinate(int x, int y)
{
    Coordinate c;
    c.x = x;
    c.y = y;
    return c;
}

// returns a coordinate array of all specified instances
Coordinate[] return_instances(Grid* g, char c)
{
    Coordinate[] instances;
    for (int i = 0; i < GRID_SIZE_Y; i++)
    {
        for (int j = 0; j < GRID_SIZE_X; j++)
        {
            if (g.grid[i][j] == c)
            {
                instances ~= (create_coordinate(i, j));
            }
        }
    }
    return instances;
}

// Return true if there is at least one alive point
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

// Return the nearest alive point, excluding self
Coordinate nearest_alive(Grid* g, int x, int y)
{
    if (!verify(x, y))
        return failed_coordinate();

    if (g.grid[y][x] != ALIVE)
        return failed_coordinate();

    // get a list of all alive points
    Coordinate[] instances = return_instances(g, ALIVE);

    foreach (Coordinate c; instances)
    {
        if (c.x != x || c.y != y)
        {
            return c;
        }
    }

    return failed_coordinate();
}

// move a point to another, making the original space empty
void grid_move(Grid *g, Coordinate from, Coordinate to)
{
    if (!verify(from.x, from.y) || !verify(to.x, to.y))
        return;
        
    char n = g.grid[from.y][from.x];
    swap(g, from.x, from.y, EMPTY);
    swap(g, to.x, to.y, n);
}

// prints an error
void error(string s)
{
    writefln("Error: %s", s);
}

// returns true if the point is alive
bool is_alive(Grid* g, int x, int y)
{
    if (!verify(x, y))
        return false;
    return g.grid[y][x] == ALIVE;
}

// prints a coordinate with a specified header, if there's no header it will
// make your header (no header specified)
void print_coordinate(Coordinate c, string header = "(no header specified)")
{
    writefln("\"%s\"\n\tx: %d, y: %d", header, c.x, c.y);
}

// prints all the instances of a specified entity
void print_all_instances(Grid* g, char c)
{
    Coordinate[] instances = return_instances(g, c);
    int INSTANCE_NUMBER = 1;

    foreach (Coordinate _c; instances)
    {
        print_coordinate(_c, format("Instance %d of '%c'", INSTANCE_NUMBER, c));
        INSTANCE_NUMBER++;
    }
}

// returns the entity to the specified direction
// up, down, left, right
// NOTE: this function only checks 1 cell in the specified direction
char get_entity_to(Grid * g, Coordinate origin,  string direction = "right") {
    if (!verify(origin.x, origin.y))
        return EMPTY;
    
    switch (direction) {
    case "up":
        return g.grid[origin.y - 1][origin.x];
    case "down":
        return g.grid[origin.y + 1][origin.x];
    case "left":
        return g.grid[origin.y][origin.x - 1];
    case "right":
        return g.grid[origin.y][origin.x + 1];
    default:
        error("Invalid direction! must be 'up', 'down', 'left' or 'right'");
    }
    return EMPTY;
}

void sleep(int seconds)
{
    Thread.sleep(dur!("seconds")(seconds));
}

// int main()
// {
//     Grid g; // declare the grid
//     init_grid(&g); // initialize the grid

//     Coordinate player = set_alive(&g, 2, 2); // set a point to alive

//     char entity = get_entity_to(&g, player, "right"); // get the entity to the right of the player

//     writefln("Entity to the right of the player is '%c'", entity);

//     print_grid(&g); // print the grid
    
//     print_all_instances(&g, ALIVE); // print all the instances of an alive entity

//     search_and_print_grid(&g); // will print any special entities

//     return 0;
// }
