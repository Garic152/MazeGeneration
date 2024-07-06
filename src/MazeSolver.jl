include("structs/Node.jl")
include("structs/Maze.jl")

module MazeSolverModule
export solve

using ..NodeModule
using ..MazeModule

function next_move(node::Node, maze::Maze, visited::Set{Node})::Union{Node, Nothing}   # Hilfsfunktion: wie der Schritt sein soll
    for neighbor in neighbors(node)
        if neighbor != nothing && !(neighbor in visited)
            return neighbor
        end
    end
    return nothing                # soll den nächsten zu besuchenden Knoten widergeben; oder nichts, wenn alle schon besucht sind

  
function solve(maze::Maze, start::Node, goal::Node)::Vector{Node}
    path = []
    visited = Set()
    current = start
    push!(path, current)      # der Weg beginnt mit dem Startpunkt
    push!(visited, current)   # und auch ist der Startpunkt schon besucht

    while current != goal
        next_node = next_move(current, maze, visited)    # immer im nächsten Schritt weiter bewegen
        if next_node != nothing
            push!(path, next_node)          # den Knoten als Kanditaten für einen Lösungsweg hinzufügen
            push!(visited, next_node)       # der Knoten soll unbedingt als besuchter markiert sein
            current = next_node
        else
            pop!(path)            # wenn nichts weiter passiert, muss es ein falscher Weg gewesen sein -> zurücktreten
            current = path[end]   # einen Schritt zurück
        end
    end
    maze.path = path              # structgemäß die Lösung ergänzen
    return path
end


end
