module MazeVizModule
using ..MazeModule: Maze, MazeViz
export visualize_maze


function visualize_maze(maze::Maze)::MazeViz     #wir machen die Visualisierung mit ASCII-Symbolen, deswegen ist der Output ein String
    output = ""
    height, width = size(maze.nodes)            # nehme die Parameter aus dem struct Maze
    path_nodes = Set(maze.path)                 # für die Lösung

    for i in 1:height
        for j in 1:width
            if maze.nodes[i, j] in path_nodes   # wenn das Pfad ist, dann anders markieren
                output *= " *"                  # mit * nämlich
            elseif maze.nodes[i, j] === nothing
                output *= "--"                  # Wand
            else



                output *= "  "                  # Durchgang
            end
        end
        output *= "\n"
    end

    viz = MazeViz(output)
    return viz
end

function Base.show(io::IO, maze::Maze)
    viz = visualize_maze(maze)
    print(io, viz.visual)
end

end
