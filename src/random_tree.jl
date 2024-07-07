import Random

module random_tree_Module
using ..NodeModule: Node
using ..MazeModule: Maze
using ..MazeSolverModule: solve
using ..MazeVizModule: visualize_maze
export maze

function maze(height::Int, width::Int)::Maze
    # Das ist der eigentliche Konstruktor.

    # Startet mit der Erzeugung der Matrix
    maze_matrix = Matrix{Union{Nothing,Node}}(nothing, height, width)

    # Sucht erstmal eine randomizierte Wurzel
    start = Node([rand(1:height), rand(1:width)], [nothing, nothing, nothing, nothing])
    maze_matrix[start.position[1], start.position[2]] = start

    # Ruft die rekursive Funktion für die Labyrinth Erstellung auf
    maze_matrix = maze_matrix_recursive(maze_matrix, start)
    goal = maze_matrix[rand(1:height), rand(1:width)]
    maze = Maze(maze_matrix, nothing, nothing, start, goal)

    maze.path = solve(maze)

    viz = visualize_maze(maze)

    maze.visual = viz

    return maze
end

function maze_matrix_recursive(maze_matrix::Matrix{Union{Nothing,Node}}, node::Node)::Matrix{Union{Nothing,Node}}
    # Macht eine rekursive Version der Tiefensuche
    next_node = set_next_node!(node, maze_matrix)
    while next_node !== nothing
        maze_matrix = maze_matrix_recursive(maze_matrix, next_node)
        next_node = set_next_node!(node, maze_matrix)
    end

    return maze_matrix

end

function available_neighbors(node::Node, maze_matrix::Matrix{Union{Nothing,Node}})
    # Sucht mit der node und der Matrix alle möglichen Nachbarn. 
    neighbors = []
    if node.position[2] != 1
        if node.neighbors[3] === nothing && maze_matrix[node.position[1], (node.position[2]-1)] === nothing
            push!(neighbors, 'l')
        end
    end
    if node.position[2] != size(maze_matrix, 2)
        if node.neighbors[1] === nothing && maze_matrix[node.position[1], node.position[2]+1] === nothing
            push!(neighbors, 'r')
        end
    end
    if node.position[1] != 1
        if node.neighbors[4] === nothing && maze_matrix[node.position[1]-1, node.position[2]] === nothing
            push!(neighbors, 't')
        end
    end
    if node.position[1] != size(maze_matrix, 1)
        if node.neighbors[2] === nothing && maze_matrix[node.position[1]+1, node.position[2]] === nothing
            push!(neighbors, 'b')
        end
    end
    return neighbors
end

function set_next_node!(node::Node, maze_matrix::Matrix{Union{Nothing,Node}})::Union{Nothing,Node}
    # Sucht mit available_neighbors alle verfügbaren Nachbarn und wählt dann einen Nachbarn zufallig aus. Passt die Matrix und die Node auch dementsprechend an. Gibt nothing zurück falls die node keine Nachbarn hat.

    neighbors = available_neighbors(node, maze_matrix)

    if isempty(neighbors)
        return nothing
    end
    next = rand(neighbors)

    if next == 'l'
        maze_matrix[node.position[1], node.position[2]-1] = Node([node.position[1], node.position[2] - 1], [nothing, nothing, nothing, nothing])
        node.neighbors[3] = maze_matrix[node.position[1], node.position[2]-1]
        return node.neighbors[3]
    elseif next == 'r'
        maze_matrix[node.position[1], node.position[2]+1] = Node([node.position[1], node.position[2] + 1], [nothing, nothing, nothing, nothing])
        node.neighbors[1] = maze_matrix[node.position[1], node.position[2]+1]
        return node.neighbors[1]
    elseif next == 't'
        maze_matrix[node.position[1]-1, node.position[2]] = Node([node.position[1] - 1, node.position[2]], [nothing, nothing, nothing, nothing])
        node.neighbors[4] = maze_matrix[node.position[1]-1, node.position[2]]
        return node.neighbors[4]
    else
        maze_matrix[node.position[1]+1, node.position[2]] = Node([node.position[1] + 1, node.position[2]], [nothing, nothing, nothing, nothing])
        node.neighbors[2] = maze_matrix[node.position[1]+1, node.position[2]]
        return node.neighbors[2]
    end
end

end
