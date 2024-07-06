using Test
include(joinpath(@__DIR__, "..", "..", "src", "structs", "Node.jl"))
include(joinpath(@__DIR__, "..", "..", "src", "structs", "Maze.jl"))
include(joinpath(@__DIR__, "..", "..", "src", "structs", "MazeViz.jl"))
include(joinpath(@__DIR__, "..", "..", "src", "random_tree.jl"))
include(joinpath(@__DIR__, "..", "..", "src", "MazeSolver.jl"))

using .NodeModule: Node, neighbors
using .MazeModule: Maze, set_index!, get_index
using .MazeVizModule: MazeViz, visualize_maze
using .random_tree_Module: maze
using .MazeSolverModule: solve

@testset "Node Struct Tests" begin
    @testset "Node Creation" begin
        position = [1, 2]
        node = Node(position, [nothing, nothing, nothing, nothing])
        @test node.position == position
        for neighbor in node.neighbors
            @test neighbor === nothing
        end
    end
    @testset "Node Creation" begin
        position = [1, 1]
        left_node = Node([0, 1], [nothing, nothing, nothing, nothing])
        right_node = Node([2, 1], [nothing, nothing, nothing, nothing])
        top_node = Node([1, 0], [nothing, nothing, nothing, nothing])
        bottom_node = Node([1, 2], [nothing, nothing, nothing, nothing])
        node = Node(position, [left_node, right_node, top_node, bottom_node])

        expected_node = [left_node, right_node, top_node, bottom_node]
        @test neighbors(node) == expected_node

        partial_node = Node(position, [nothing, nothing, top_node, bottom_node])
        expected_partial_node = [top_node, bottom_node]
        @test neighbors(partial_node) == expected_partial_node
    end
end

@testset "Maze Struct Tests" begin
    # This only is a really basic test
    # #because at the time this code was written only task 1 got solved so far
    @testset "Maze Constructor" begin
        empty_maze = Maze(1, 2)
        @test typeof(empty_maze.nodes) == Matrix{Node}
        @test size(empty_maze.nodes) == (1, 2)
    end
    @testset "Full Maze Creation" begin
        # This is missing
    end
    @testset "Set Index Success" begin
        maze = Maze(2, 2)
        node = Node([2, 2], [nothing, nothing, nothing, nothing])
        set_index!(maze, node)
        @test maze.nodes[2, 2] == node
    end
    @testset "Set Index Fail" begin
        maze = Maze(2, 2)
        node1 = Node([2, 3], [nothing, nothing, nothing, nothing])
                              node2 = Node([3, 2], [nothing, nothing, nothing, nothing])
                              node3 = Node([0, 0], [nothing, nothing, nothing, nothing])
        @test set_index!(maze, node1) == -1
        @test set_index!(maze, node2) == -1
        @test set_index!(maze, node3) == -1
    end
    @testset "Get Index Success" begin
        maze = Maze(2, 2)
        node = Node([2, 2], [nothing, nothing, nothing, nothing])
        set_index!(maze, node)
        @test get_index(maze, 2, 2) == node
    end
    @testset "Get Index Fail" begin
        maze = Maze(2, 2)
        @test get_index(maze, 2, 3) == -1
        @test get_index(maze, 3, 2) == -1
        @test get_index(maze, 0, 0) == -1
    end
end

@testset "Maze Generation and Visualization Tests" begin                                 # neu
    @testset "Random Maze Generation" begin
        random_maze = maze(5, 5)  # Generiere ein 5x5 Labyrinth
        @test typeof(random_maze) == Maze
        @test size(random_maze.nodes) == (5, 5)
        visited_nodes = 0
        for i in 1:5, j in 1:5
            if random_maze.nodes[i, j] != nothing
                visited_nodes += 1
            end
        end
        @test visited_nodes == 25  # Alle Knoten sollten besucht sein
    end
    
    @testset "Maze Visualization" begin
        simple_maze = Maze(3, 3)
        for i in 1:3, j in 1:3
            set_index!(simple_maze, Node([i, j], [nothing, nothing, nothing, nothing]))
        end
        viz = MazeViz(simple_maze)
        visualization = visualize_maze(simple_maze)
        @test typeof(visualization) == String
        println(visualization)  # Prüfe die Konsolenausgabe manuell
    end
end

@testset "Maze Solver Tests" begin
    @testset "Simple Maze Solution" begin
        simple_maze = Maze(3, 3)
        nodes = [Node([i, j], [nothing, nothing, nothing, nothing]) for i in 1:3, j in 1:3]
        for i in 1:3, j in 1:3
            set_index!(simple_maze, nodes[i, j])
        end
        
        # Manuell Nachbarn setzen, um einfachen Weg zu erstellen
        nodes[1, 1].neighbors = [nodes[1, 2], nothing, nothing, nothing]
        nodes[1, 2].neighbors = [nodes[1, 3], nodes[1, 1], nothing, nothing]
        nodes[1, 3].neighbors = [nothing, nodes[1, 2], nothing, nodes[2, 3]]
        nodes[2, 3].neighbors = [nothing, nothing, nodes[1, 3], nothing]
        
        start = nodes[1, 1]
        goal = nodes[2, 3]
        path = solve(simple_maze, start, goal)
        
        @test length(path) > 0
        @test path[1] == start
        @test path[end] == goal
    end
    
    @testset "Complex Maze Solution" begin
        complex_maze = maze(5, 5)  # Generiere ein 5x5 Labyrinth
        start = complex_maze.nodes[1, 1]
        goal = complex_maze.nodes[5, 5]
        path = solve(complex_maze, start, goal)
        
        @test length(path) > 0
        @test path[1] == start
        @test path[end] == goal
    end
end
