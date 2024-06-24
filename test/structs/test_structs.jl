using Test
include(joinpath(@__DIR__, "..", "..", "src", "structs", "Node.jl"))
include(joinpath(@__DIR__, "..", "..", "src", "structs", "Maze.jl"))

using .NodeModule: Node, neighbors
using .MazeModule: Maze, set_index!, get_index

@testset "Node Struct Tests" begin
    @testset "Node Creation" begin
        position = [1, 2]
        node = Node(position, nothing, nothing, nothing, nothing)
        @test node.position == position
        @test node.left_child === nothing
        @test node.right_child === nothing
        @test node.top_child === nothing
        @test node.bottom_child === nothing
    end
    @testset "Node Creation" begin
        position = [1, 1]
        left_node = Node([0, 1], nothing, nothing, nothing, nothing)
        right_node = Node([2, 1], nothing, nothing, nothing, nothing)
        top_node = Node([1, 0], nothing, nothing, nothing, nothing)
        bottom_node = Node([1, 2], nothing, nothing, nothing, nothing)
        node = Node(position, left_node, right_node, top_node, bottom_node)

        expected_node = [left_node, right_node, top_node, bottom_node]
        @test neighbors(node) == expected_node

        partial_node = Node(position, nothing, nothing, top_node, bottom_node)
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
        node = Node([2, 2], nothing, nothing, nothing, nothing)
        set_index!(maze, node)
        @test maze.nodes[2, 2] == node
    end
    @testset "Set Index Fail" begin
        maze = Maze(2, 2)
        node1 = Node([2, 3], nothing, nothing, nothing, nothing)
        node2 = Node([3, 2], nothing, nothing, nothing, nothing)
        node3 = Node([0, 0], nothing, nothing, nothing, nothing)
        @test set_index!(maze, node1) == -1
        @test set_index!(maze, node2) == -1
        @test set_index!(maze, node3) == -1
    end
    @testset "Get Index Success" begin
        maze = Maze(2, 2)
        node = Node([2, 2], nothing, nothing, nothing, nothing)
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
