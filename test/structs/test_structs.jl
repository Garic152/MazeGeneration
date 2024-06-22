using Test
src_file_path = joinpath(@__DIR__, "..", "..", "src", "structs", "Node.jl")
include(src_file_path)

using .NodeModule: Node, neighbors

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
