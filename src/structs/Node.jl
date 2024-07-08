"""
# NodeModule

This module implements the Node structure used throughout the project.
"""
module NodeModule
export Node, neighbors

mutable struct Node
  """
  The core representation of the nodes used in the project.

  # Fields
  - `position::Vector{Int}`: A 2D vector containing the position of the node in the maze.
  - `neighbors::Array{Union{Node, Nothing}}`: The neighbor nodes in order [right, bottom, left. top].
  """
  position::Vector{Int}
  neighbors::Array{Union{Node,Nothing}}
end

function neighbors(node::Node)
  """
  Returns the neighbors of a node.

  # Arguments
  - `node::Node`: The node to get the neighbors from.

  # Returns
  - `Array{Node}`: An array containing all the non-nothing neighbors of a node.
  """
  neighbors = []
  for neighbor in node.neighbors
    if neighbor !== nothing
      push!(neighbors, neighbor)
    end
  end
  return neighbors
end

end
