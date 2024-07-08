include("structs/Node.jl")
include("structs/Maze.jl")
include("structs/MazeViz.jl")
include("MazeSolver.jl")
include("random_tree.jl")

using .NodeModule
using .MazeModule
using .MazeVizModule
using .MazeSolverModule
using .random_tree_Module

X = maze(30, 30)
print(X)
