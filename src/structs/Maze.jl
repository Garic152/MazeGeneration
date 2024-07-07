module MazeModule
using ..NodeModule: Node
export Maze, maze_empty, MazeViz, set_index!, get_index

mutable struct MazeViz
  visual::String
end


mutable struct Maze
  nodes::Matrix{Node}
  visual::Union{Nothing,MazeViz}
  path::Union{Vector{Node},Nothing}
  start::Union{Node,Nothing}
  goal::Union{Node,Nothing}
end


function maze_empty(height::Int, width::Int)
  return Maze(Matrix{Node}(undef, height, width), nothing, nothing, nothing, nothing)
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
