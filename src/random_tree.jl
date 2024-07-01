import Random

include("structs/Node.jl")
include("structs/Maze.jl")

module random_tree_Module

using ..NodeModule
using ..MazeModule

function maze(height::Int, width::Int)::Maze
    # Das ist der eigentliche Konstruktor.

    # Startet mit der Erzeugung der Matrix
    maze_matrix = [Union{Nothing,Node}[nothing for i in 1:height] for j in 1:width];

    # Sucht erstmal eine randomizierte Wurzel
    root = Node( [rand(1:height), rand(1:width)], nothing, nothing, nothing, nothing);
    maze_matrix[root.position[1]][root.position[2]] = root;

    # Ruft die rekursive Funktion für die Labyrinth Erstellung auf
    maze_matrix = maze_matrix_recursive(maze_matrix, root);

    maze = Maze(maze_matrix, nothing, nothing);

    return maze
end

function maze_matrix_recursive(maze_matrix::Vector{Vector{Union{Nothing, Node}}}, node::Node)::Vector{Vector{Union{Nothing, Node}}}
    # Macht eine rekursive Version der Tiefensuche
    next_node = set_next_node!(node, maze_matrix);
    while next_node !== nothing
        maze_matrix = maze_matrix_recursive(maze_matrix, next_node);
        next_node = set_next_node!(node, maze_matrix);
    end

    return maze_matrix

end

function available_neighbors(node::Node, maze_matrix::Vector{Vector{Union{Nothing, Node}}})
    # Sucht mit der node und der Matrix alle möglichen Nachbarn. 
    neighbors = []
    if node.position[2] != 1
        if node.left_child === nothing && maze_matrix[node.position[1]][node.position[2] - 1] === nothing
        push!(neighbors, 'l')
        end
    end
    if node.position[2] != length(maze_matrix[1])
        if node.right_child === nothing && maze_matrix[node.position[1]][node.position[2] + 1] === nothing
        push!(neighbors, 'r')
        end
    end
    if node.position[1] != 1
        if node.top_child === nothing && maze_matrix[node.position[1] - 1][node.position[2]] === nothing
        push!(neighbors, 't')
        end
    end
    if node.position[1] != length(maze_matrix)
        if node.bottom_child === nothing && maze_matrix[node.position[1] + 1][node.position[2]] === nothing
        push!(neighbors, 'b')
        end
    end
    return neighbors
end

function set_next_node!(node::Node, maze_matrix::Vector{Vector{Union{Nothing, Node}}})::Union{Nothing, Node}
    # Sucht mit available_neighbors alle verfügbaren Nachbarn und wählt dann einen Nachbarn zufallig aus. Passt die Matrix und die Node auch dementsprechend an. Gibt nothing zurück falls die node keine Nachbarn hat.
    
    neighbors = available_neighbors(node, maze_matrix);

    if isempty(neighbors)
        return nothing
    end
    next = rand(neighbors);

    if next == 'l'
        maze_matrix[node.position[1]][node.position[2] - 1] = Node([node.position[1], node.position[2] - 1], nothing, nothing, nothing, nothing);
        node.left_child = maze_matrix[node.position[1]][node.position[2] - 1];
        return node.left_child
    elseif next == 'r'
        maze_matrix[node.position[1]][node.position[2] + 1] = Node([node.position[1], node.position[2] + 1], nothing, nothing, nothing, nothing);
        node.right_child = maze_matrix[node.position[1]][node.position[2] + 1];
        return node.right_child
    elseif next == 't'
        maze_matrix[node.position[1] - 1][node.position[2]] = Node([node.position[1] - 1, node.position[2]], nothing, nothing, nothing, nothing);
        node.top_child = maze_matrix[node.position[1] - 1][node.position[2]];
        return node.top_child
    else
        maze_matrix[node.position[1] + 1][node.position[2]] = Node([node.position[1] + 1, node.position[2]], nothing, nothing, nothing, nothing);
        node.bottom_child = maze_matrix[node.position[1] + 1][node.position[2]];
        return node.bottom_child
    end
end

end
