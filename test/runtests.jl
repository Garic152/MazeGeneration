using Pkg
Pkg.activate("..")  # Activate the project environment
using Test

include("../src/MazeGeneration.jl")

include("structs/test_structs.jl")
include("util/test_generation.jl")

@testset "MazeGeneration Tests" begin
  @testset "Struct Tests" begin
    include("structs/test_structs.jl")
  end

  @testset "Generation Tests" begin
    include("util/test_generation.jl")
  end

  @testset "Visualization Tests" begin
    include("util/test_visualization.jl")
  end

  @testset "Maze Solve Tests" begin
    include("util/test_solution.jl")
  end
end

