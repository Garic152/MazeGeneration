include("Node.jl")
include("Maze.jl")


module MazeVizModule
export MazeViz, visualize_maze

using ..MazeModule
using ..NodeModule

struct MazeViz
  maze::Maze
end

function visualize_maze(viz::MazeViz)::String #wir machen die Visualisierung mit ASCII-Symbolen, deswegen ist der Output ein String
  maze = viz.maze
  height, width = size(maze.nodes) # nehme die Parameter aus dem struct Maze
  output = []

  # mache erstmal die "Decke": zwei Ecken und die entprechende Mitte
  push!(output, "┌" * "─"^width * "┐")

  # nun mache die Wände
  for i in 1:height #mache das zeilenweise, von oben nach unten
    row = "│"
    for j in 1:width
      node = get_index(maze, i, j)
      if node in viz.maze.path
        row *= "·"  # Weg im Labyrinth
      elseif node == viz.maze.start
        row *= "S"  # Startpunkt
      elseif node == viz.maze.goal
        row *= "G"  # Zielpunkt
      else
        row *= "█"  # normale Zelle im Labyrinth
      end
    end
    row *= "│"
    push!(output, row)
  end

  # nun den "Boden", analog zur Decke
  push!(output, "└" * "─"^width * "┘")

  # alles zusammenjoinen und widergeben
  return join(output, "\n")
end

end
