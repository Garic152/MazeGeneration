import Random

include("structs/Node.jl")
include("structs/Maze.jl")
using ..NodeModule
using ..MazeModule

function maze(height::Int, width::Int)::Maze

    maze_matrix = [Union{Nothing,Node}[nothing for i in 1:height] for j in 1:width];

    root = Node( [rand(1:height), rand(1:width)], nothing, nothing, nothing, nothing);
    maze_matrix[root.position[1]][root.position[2]] = root;


    # next_node = set_next_node!(root, maze_matrix);
    # predecessor = next_node;
    # while predecessor != root
    #     predecessor = next_node;
    #     next_node = set_next_node!(next_node, maze_matrix);
    #     if next_node === nothing
    #         next_node = predecessor;
    #     end
    # end
    maze_matrix = maze_matrix_recursive(maze_matrix, root);

    maze = Maze(maze_matrix, nothing, nothing);

    return maze
end

function maze_matrix_recursive(maze_matrix::Vector{Vector{Union{Nothing, Node}}}, node::Node)::Vector{Vector{Union{Nothing, Node}}}
    
    next_node = set_next_node!(node, maze_matrix);
    while next_node !== nothing
        maze_matrix = maze_matrix_recursive(maze_matrix, next_node);
        next_node = set_next_node!(node, maze_matrix);
    end

    return maze_matrix

end

function availible_neighbors(node::Node, maze_matrix::Vector{Vector{Union{Nothing, Node}}})
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

    neighbors = availible_neighbors(node, maze_matrix);

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

# height = 3;
# width = 3;

# maze_matrix = [Union{Nothing,Node}[nothing for i in 1:height] for j in 1:width];
# root = Node( [rand(1:height), rand(1:width)], nothing, nothing, nothing, nothing);
# maze_matrix[root.position[1]][root.position[2]] = root;
# println
# println(maze_matrix)
# maze_matrix[1][1] = Node( [1, 1], nothing, nothing, nothing, nothing)
# println(maze_matrix)
# list = availible_neighbors(maze_matrix[1][1], maze_matrix);
# println(list);
# list = [];
# println(rand(list));

mmaze = maze(5,5);
for i in mmaze.nodes
    println(i)
end