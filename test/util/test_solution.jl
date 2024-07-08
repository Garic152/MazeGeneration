@testset "test_maze Solver Tests" begin
  @testset "1x1 Maze" begin
    test_maze = maze(1, 1)
    @test length(test_maze.path) == 1
    @test test_maze.path[1].position == [1, 1]
    @test test_maze.path[1].neighbors == [nothing, nothing, nothing, nothing]
  end
  @testset "2x2 Maze" begin
    Random.seed!(12)

    test_maze = maze(2, 2)
    @test length(test_maze.path) == 4

    solution_vector = [[1, 2], [2, 2], [2, 1], [1, 1]]

    for (correct_pos, result) in zip(solution_vector, test_maze.path)
      generated_pos = result.position
      @test correct_pos == generated_pos
    end
    @testset "3x3 Maze" begin
      Random.seed!(12345)

      test_maze = maze(3, 3)
      @test length(test_maze.path) == 7

      solution_vector = [[3, 3], [3, 2], [3, 1], [2, 1], [2, 2], [1, 2], [1, 3]]

      for (correct_pos, result) in zip(solution_vector, test_maze.path)
        generated_pos = result.position
        @test correct_pos == generated_pos
      end
    end

    @testset "4x4 Maze with all possible goals" begin
      test_maze = maze(4, 4)
      for i = 1:4
        for j = 1:4
          test_maze.goal = test_maze.nodes[i, j]
          solution = solve(test_maze)
          @test solution[length(solution)] == test_maze.goal
        end
      end
    end

  end
end
