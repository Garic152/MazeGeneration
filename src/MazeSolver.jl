"""
# MazeSolverModule

This module provides functionality to solve any generated maze from random_tree.jl
"""

module MazeSolverModule
export solve

using ..NodeModule
using ..MazeModule
using ..MazeVizModule

function it!(node::Node, current_neighbor::Int, goal::Node)::Vector{Node}
    """
    Recursively steps into the given root node and assembles the solution vector

    # Arguments
    - `node::Node`: The root node of the tree.
    - `current_neighbor::Int`: The index of the current neighbor to check.
    - `goal::Node`: The goal node to reach.

    # Returns
    - `Vector{Node}`: A vector containing the individual node positions on the solution path.
    """
    if node.position == goal.position
        return [node]
    end
    for i = 0:3
        neighbor = node.neighbors[(current_neighbor+i)%4+1]
        if neighbor !== nothing
            x = it!(neighbor, (current_neighbor + 1) % 4 + 1, goal)
            if x == []
                continue
            else
                return [node; x]
            end
        else
            continue
        end
    end
    return []
end

function solve(maze::Maze)::Vector{Node}
    """
    Initializes the iterator function and returns its solution

    # Arguments
    - `maze::Maze`: The maze to solve

    # Returns
    - `Vector{Node}`: A vector containing the individual node positions on the solution path.
    """
    solution = it!(maze.start, 1, maze.goal)
    return solution
end

end
