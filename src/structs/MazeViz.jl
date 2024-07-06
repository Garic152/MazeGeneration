include("Maze.jl")

module MazeVizModule
export MazeViz, visualize_maze
using ..MazeModule

struct MazeViz
    maze::Maze
end

function visualize_maze(maze::Maze)::String     #wir machen die Visualisierung mit ASCII-Symbolen, deswegen ist der Output ein String
    output = ""
    height, width = size(maze.nodes)            # nehme die Parameter aus dem struct Maze
    for i in 1:height
        for j in 1:width
            if maze.nodes[i, j] == nothing
                output *= "██"                  # Wand
            else
                output *= "  "                  # Durchgang
            end
        end
        output *= "\n"
    end
    return output
end

function Base.show(io::IO, viz::MazeViz)
    print(io, visualize_maze(viz.maze))
end

end
