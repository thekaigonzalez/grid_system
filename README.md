# Grid Framework

a simple grid-based system written in D that provides a grid map similar to the one in
https://github.com/thekaigonzalez/tinysoccer

> In summary, this code serves as a starting point for working with 2D grids and
> simulating environments where cells can be different types. While the code
> itself is relatively basic, it can be a foundation for more complex
> simulations, such as **Conway's Game of Life** or other cellular automata models,
> by extending the functionality and rules for cell interactions.

## Modularity

This library is very extensible and can be used to generate a variety of different
grid-based systems.

It contains many functions for generating, manipulating, and rendering grids. It
also contains a basic implementation of the [Conway's Game of
Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) model, generated by
ChatGPT, to easily display the ease-of-use of this library.

## Installation

To use this library, all you have to do is copy `grid.d` into your project. This
library is not exclusive and you are able to expand on it and implement
different features to aid in making your grid-based project much easier to work
with.

## Example

This is an example grid system which uses a majority of the functions in this
library.

```d
int main()
{
    Grid g; // declare the grid
    init_grid(&g); // initialize the grid

    Coordinate player = set_alive(&g, 2, 2); // set a point to alive

    char entity = get_entity_to(&g, player, "right"); // get the entity to the right of the player

    writefln("Entity to the right of the player is '%c'", entity);

    print_grid(&g); // print the grid
    
    print_all_instances(&g, ALIVE); // print all the instances of an alive entity

    search_and_print_grid(&g); // will print any special entities

    return 0;
}
```
