import Random

include("structs/Maze.jl")

module random_tree_Module

using ..NodeModule
using ..MazeModule

function maze(height::Int, width::Int)::Maze
    # Das ist der eigentliche Konstruktor.

    # Startet mit der Erzeugung der Matrix
    # maze_matrix = [Union{Nothing,Node}[nothing for i in 1:width] for j in 1:height];
    maze_matrix = Matrix{Union{Nothing, Node}}(undef, height, width);

    # Alle undefinierten Werte durch nothing ersetzen
    for i in 1:size(maze_matrix, 1)
        for j in 1:size(maze_matrix, 2)
            maze_matrix[i, j] = nothing
        end
    end

    # Sucht erstmal eine randomizierte Wurzel
    root = Node( [rand(1:height), rand(1:width)], [nothing, nothing, nothing, nothing]);
    maze_matrix[root.position[1], root.position[2]] = root;

    # Ruft die rekursive Funktion für die Labyrinth Erstellung auf
    maze_matrix = maze_matrix_recursive(maze_matrix, root);

    maze = Maze(maze_matrix, nothing, nothing);

    return maze
end

function maze_matrix_recursive(maze_matrix::Matrix{Union{Nothing, Node}}, node::Node)::Matrix{Union{Nothing, Node}}
    # Macht eine rekursive Version der Tiefensuche
    next_node = set_next_node!(node, maze_matrix);
    while next_node !== nothing
        maze_matrix = maze_matrix_recursive(maze_matrix, next_node);
        next_node = set_next_node!(node, maze_matrix);
    end

    return maze_matrix

end

function available_neighbors(node::Node, maze_matrix::Matrix{Union{Nothing, Node}})
    # Sucht mit der node und der Matrix alle möglichen Nachbarn. 
    neighbors = []
    if node.position[2] != 1
        if node.neighbors[3] === nothing && maze_matrix[node.position[1], (node.position[2] - 1)] === nothing
        push!(neighbors, 'l')
        end
    end
    if node.position[2] != size(maze_matrix, 2)
        if node.neighbors[1] === nothing && maze_matrix[node.position[1], node.position[2] + 1] === nothing
        push!(neighbors, 'r')
        end
    end
    if node.position[1] != 1
        if node.neighbors[4] === nothing && maze_matrix[node.position[1] - 1, node.position[2]] === nothing
        push!(neighbors, 't')
        end
    end
    if node.position[1] != size(maze_matrix,1)
        if node.neighbors[2] === nothing && maze_matrix[node.position[1] + 1, node.position[2]] === nothing
        push!(neighbors, 'b')
        end
    end
    return neighbors
end

function set_next_node!(node::Node, maze_matrix::Matrix{Union{Nothing, Node}})::Union{Nothing, Node}
    # Sucht mit available_neighbors alle verfügbaren Nachbarn und wählt dann einen Nachbarn zufallig aus. Passt die Matrix und die Node auch dementsprechend an. Gibt nothing zurück falls die node keine Nachbarn hat.
    
    neighbors = available_neighbors(node, maze_matrix);

    if isempty(neighbors)
        return nothing
    end
    next = rand(neighbors);

    if next == 'l'
        maze_matrix[node.position[1], node.position[2] - 1] = Node([node.position[1], node.position[2] - 1], [nothing, nothing, nothing, nothing]);
        node.neighbors[3] = maze_matrix[node.position[1], node.position[2] - 1];
        return node.neighbors[3]
    elseif next == 'r'
        maze_matrix[node.position[1], node.position[2] + 1] = Node([node.position[1], node.position[2] + 1], [nothing, nothing, nothing, nothing]);
        node.neighbors[1] = maze_matrix[node.position[1], node.position[2] + 1];
        return node.neighbors[1]
    elseif next == 't'
        maze_matrix[node.position[1] - 1, node.position[2]] = Node([node.position[1] - 1, node.position[2]], [nothing, nothing, nothing, nothing]);
        node.neighbors[4] = maze_matrix[node.position[1] - 1, node.position[2]];
        return node.neighbors[4]
    else
        maze_matrix[node.position[1] + 1, node.position[2]] = Node([node.position[1] + 1, node.position[2]], [nothing, nothing, nothing, nothing]);
        node.neighbors[2] = maze_matrix[node.position[1] + 1, node.position[2]];
        return node.neighbors[2]
    end
end

end
