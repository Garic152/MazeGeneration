include("Node.jl")
include("MazeViz.jl") ############ ob es okay ist, dass wir Maze in MazeViz sowie auch MazeViz in Maze includen?

module MazeModule
export Maze
using ..NodeModule

struct Maze
  nodes::Matrix{Node}
  # import MatrixVisualization ########### das verstehe ich nicht so ganz, ob wir das brauchen
  visual::Union{MazeViz,Nothing}
  path::Union{Vector{Node}, Nothing}
  start::Union{Node, Nothing} ################## Neu: Beginn des Lösungspfades
  goal::Union{Node, Nothing} ################### Neu: Ende des Lösungspfades

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

############################################## NEUES, WAS ES NICHT IN MAIN GIBT #####################################
function Base.show(io::IO, maze::Maze)
  if maze.visual != nothing
    println(io, visualize_maze(maze.visual))
  else
    println(io, "Maze visualization not available.") ######### das ist ein Testsatz, später löschen
  end
end
######################################################################################################################

end


