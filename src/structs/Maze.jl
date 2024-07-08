"""
# MazeModule

This module implements the Maze structure used throughout the project.
"""

module MazeModule
using ..NodeModule: Node
export Maze, maze_empty, MazeViz, set_index!, get_index

mutable struct MazeViz
  """
  A visual representation of the Maze with its solution as a string.
  """
  visual::String
end


mutable struct Maze
  """
  The core representation of the mazes used in the project.

  # Fields
  - `nodes::Matrix{Node}`: A matrix of nodes representing the maze.
  - `visual::Union{Nothing, MazeViz}`: An empty visual representation of the maze.
  - `path::Union{Vector{Node},Nothing}`: An empty solution path.
  - `start::Union{Node,Nothing}`: An empty start node.
  - `goal::Union{Node,Nothing`: An empty goal node.
  """
  nodes::Matrix{Node}
  visual::Union{Nothing,MazeViz}
  path::Union{Vector{Node},Nothing}
  start::Union{Node,Nothing}
  goal::Union{Node,Nothing}
end


function maze_empty(height::Int, width::Int)
  """
  Creates an empty maze with the specified height and width.

  # Arguments
  - `height::Int`: The height of the maze.
  - `width::Int`: The width of the maze.

  # Returns
  - `Maze`: An empty maze structure.
  """
  return Maze(Matrix{Node}(undef, height, width), nothing, nothing, nothing, nothing)
end

function set_index!(maze::Maze, node::Node)
  """
  Sets the index of the maze to a specified node.

  # Arguments:
  - `maze::Maze`: The maze to change the index in.
  - `node::Node`: The node to be inserted.
  """
  if node.position[1] < 1 || node.position[1] > size(maze.nodes, 1) || node.position[2] < 1 || node.position[2] > size(maze.nodes, 2)
    # out of bounds
    return -1
  end
  maze.nodes[node.position[1], node.position[2]] = node
end

function get_index(maze::Maze, height::Int, width::Int)
  """
  Gets the node at a specific index in the Matrix.

  # Arguments:
  - `maze::Maze`: The maze to get the node from.
  - `height::Int`: The height of the index.
  - `width::Int`: The width of the index.
  """
  if height < 1 || height > size(maze.nodes, 1) || width < 1 || width > size(maze.nodes, 2)
    # out of bounds
    return -1
  end
  return maze.nodes[height, width]
end

end
