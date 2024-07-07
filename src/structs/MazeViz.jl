module MazeVizModule
using ..MazeModule: Maze, MazeViz
export visualize_maze

function visualize_maze(maze::Maze)::MazeViz     #wir machen die Visualisierung mit ASCII-Symbolen, deswegen ist der Output ein String

    height, width = size(maze.nodes)                # nehme die Parameter aus dem struct Maze
    ceiling_top = "┌"
    ceiling_bottom = "└"
    for i in 1:width
        ceiling_top *= "--"
        ceiling_bottom *= "--"
    end
    ceiling_top *= "┐\n"
    ceiling_bottom *= "┘\n"

    path_nodes = Set(maze.path)                 # für die Lösung
    output = ceiling_top
    for i in 1:height
        output *= "|"
        for j in 1:width
            if maze.nodes[i, j] in path_nodes   # wenn das Pfad ist, dann anders markieren
                output *= "* "                  # mit * nämlich
            elseif maze.nodes[i, j] === nothing
                output *= "--"                  # Wand
            else

                output *= "  "                  # Durchgang
            end
        end
        output *= "|\n"
    end
    output *= ceiling_bottom

    viz = MazeViz(output)
    return viz
end


function Base.show(io::IO, maze::Maze)
    viz = visualize_maze(maze)
    print(io, viz.visual)
end

end
