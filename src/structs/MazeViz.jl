module MazeVizModule
using ..MazeModule: Maze, MazeViz
using ..NodeModule: Node
using Match
export visualize_maze


function visualize_maze(maze::Maze)::MazeViz     
    # Funktion für die Visualisierung des Labyrinths.
    # Arguments:
    #   maze:   Übergebenes Labyrinth das visualisiert werden sollene
    # Gibt den MazeViz struct zurück.

    height, width = size(maze.nodes)                
    
    # Eine Matrix für das visualisierte Labyrinth erstellen
    output_list = Matrix{Union{Nothing, String}}(nothing, 2*height + 1 , 2*width + 1)
    output_list[1,1] = " ┌─"
    output_list[2*height + 1, 1] = " └─"
    output_list[1, 2*width + 1] = "─┐ "
    output_list[2*height + 1 , 2*width + 1] = "─┘ "
    output_list[1,:] .= "───"
    output_list[2*height + 1,:] .= "───"
    output_list[:,1] .= " | "
    output_list[:,2*width + 1] .= " | "

    # Für die Lösung eine Liste aus allen Koordinaten der Knoten, die für die Lösung notwendig sind.
    position_list = []
    for node in maze.path
        push!(position_list, (node.position))
    end

    # Die maze_matrix und die Lösung in die output_list transferieren
    for i in 1:height
        for j in 1:width
            
            if [i,j] in position_list
                output_list[2 * i, 2 * j] = " + "
                node = maze.nodes[i, j]         # right, bottom, left, top
                if node.neighbors[1] !== nothing
                    if [i, j + 1] in position_list 
                        output_list[2*i, 2*j + 1] = " + "
                    else
                        output_list[2*i, 2*j + 1] = "   "
                    end
                end
                if node.neighbors[2] !== nothing
                    if [i + 1, j] in position_list 
                        output_list[2*i + 1, 2*j] = " + "
                    else
                        output_list[2*i + 1, 2*j] = "   "
                    end
                end
                if node.neighbors[3] !== nothing
                    if [i, j - 1] in position_list 
                        output_list[2*i, 2*j - 1] = " + "
                    else
                        output_list[2*i, 2*j - 1] = "   "
                    end
                end
                if node.neighbors[4] !== nothing
                    if [i - 1, j] in position_list 
                        output_list[2*i - 1, 2*j] = " + "
                    else
                        output_list[2*i - 1, 2*j] = "   "
                    end
                end
            else
                output_list[2*i, 2*j] = "   "
                node = maze.nodes[i, j]         # right, bottom, left, top
                if node.neighbors[1] !== nothing
                    output_list[2*i, 2*j + 1] = "   "
                end
                if node.neighbors[2] !== nothing
                    output_list[2*i + 1, 2*j] = "   "
                end
                if node.neighbors[3] !== nothing
                    output_list[2*i, 2*j - 1] = "   "
                end
                if node.neighbors[4] !== nothing
                    output_list[2*i - 1, 2*j] = "   "
                end
            end
        end
    end

    # Restliche Wände für die Darstellung auswählen
    for i in 1:2*height+1
        for j in 1:2*width+1
            if i % 2 == 0 && j % 2 == 0
                continue
            end
            if output_list[i, j] == "   " || output_list[i, j] == " + "
                continue
            end
            possible_neighbors = get_possible_neighbors(output_list, i, j)
            output_list[i, j] = choose_right_edge(possible_neighbors)
            
        end
    end
    
    output_list[2 * maze.start.position[1], 2 * maze.start.position[2]] = " ⁕ "
    output_list[2 * maze.goal.position[1], 2 * maze.goal.position[2]] = " ⛿ "

    # Output in einen String zusammenfassen 
    output = ""
    for i in 1:2*height+1
        for j in 1:2*width+1
            output *= output_list[i, j]
        end
        output *= "\n"
    end

    viz = MazeViz(output)
    return viz
end


function get_possible_neighbors(list::Matrix{Union{Nothing, String}}, i::Int, j::Int)::Vector{Int}
    # Erstellt eine codierte Liste aus allen möglichen Nachbarwänden, um das richtige Wandstück auszuwählen.
    # Arguments:
    #   list:   Um Wände erweiterte Labyrinth-Matrix
    #   i:      Aktuelle Höhenkoordinate für die Liste
    #   j:      Aktuelle Breitenkoordinate für die Liste
    # Gibt einen kodierten Vektor mit 4 Einträgen zurück.

    height, width = size(list)

    possible_neighbors = [1,1,1,1]          
    if i > 1
        if list[i - 1, j] !== "   " && list[i - 1, j] !== " + " # top wall
            possible_neighbors[4] = 0
        end
    end
    if i < height
        if list[i + 1, j] !== "   " && list[i + 1, j] !== " + "   # bottom wall
            possible_neighbors[2] = 0
        end
    end
    if j > 1
        if list[i, j - 1] !== "   " && list[i, j - 1] !== " + "    # left wall
            possible_neighbors[3] = 0
        end
    end
    if j < width 
        if list[i, j + 1] !== "   " && list[i, j + 1] !== " + "      # right wall
            possible_neighbors[1] = 0
        end
    end            

    return possible_neighbors 
end


function choose_right_edge(possible_neighbors::Vector{Int})::String
    # Wählt aus einem codierten Vektor das richtige Wandelement aus.
    # Zu wählende Wandelemente:  ─ | ┌ └ ┐ ┘ ├ ┤ ┬ ┴ ╴ ╵ ╶ ╷
    # Arguments:
    #   possible_neighbors: Codierter Vektor bestehend aus 1 und 0. Jeder Wert steht für eine mögliche Richtung.
    #                       Ist in folgender Reihenfolge codiert: right, bottom, left, top 
    #                       1: Zur entsprechenden Richtung ist keine Wandverbindung notwendig
    #                       0: Zur entsprechenden Richtung ist eine Wandverbindung notwendig
    # Gibt den ausgewählten String zurück

    str = @match possible_neighbors begin
        [0,0,0,0] => "─┼─"
        [0,0,0,1] => "─┬─"
        [0,0,1,0] => " ├─"
        [0,0,1,1] => " ┌─"
        [0,1,0,0] => "─┴─"
        [0,1,0,1] => "───"
        [0,1,1,0] => " └─"
        [0,1,1,1] => " ╶─"
        [1,0,0,0] => "─┤ "
        [1,0,0,1] => "─┐ "
        [1,0,1,0] => " │ "
        [1,0,1,1] => " ╷ "
        [1,1,0,0] => "─┘ "
        [1,1,0,1] => "─╴ "
        [1,1,1,0] => " ╵ "
        [1,1,1,1] => "   "
    end

    return str    
end


function Base.show(io::IO, maze::Maze)
    # Überläd die Darstellung für das Labyrinth mit der erstellten Visualisierung.
    
    viz = visualize_maze(maze)
    print(io, viz.visual)
end

end
