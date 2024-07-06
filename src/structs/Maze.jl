include("Node.jl")

module MazeModule
export Maze
using ..NodeModule

struct Maze
  nodes::Matrix{Node}
  visual::Nothing  # PLatzhalter: später für MazeViz
  path::Union{Vector{Node}, Nothing}

  Maze(height::Int, width::Int) = new(Matrix{Node}(undef, height, width), nothing, nothing)
end

function set_index!(maze::Maze, node::Node)
  if node.position[1] < 1 || node.position[1] > size(maze.nodes, 1) || node.position[2] < 1 || node.position[2] > size(maze.nodes, 2)
    # out of bounds
    return -1
  end
  maze.nodes[node.position[1], node.position[2]] = node
end

function get_index(maze::Maze, height::Int, width::Int)
  if height < 1 || height > size(maze.nodes, 1) || width < 1 || width > size(maze.nodes, 2)
    # out of bounds
    return -1
  end
  return maze.nodes[height, width]
end

end


