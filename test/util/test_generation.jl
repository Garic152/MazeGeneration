@testset "Maze Generation and Visualization Tests" begin                                 # neu
  @testset "Random Maze Generation" begin
    random_maze = maze(5, 5)  # Generiere ein 5x5 Labyrinth
    @test typeof(random_maze) == Main.MazeModule.Maze
    @test size(random_maze.nodes) == (5, 5)
    visited_nodes = 0
    for i in 1:5, j in 1:5
      if random_maze.nodes[i, j] !== nothing
        visited_nodes += 1
      end
    end
    @test visited_nodes == 25  # Alle Knoten sollten besucht sein
  end

  @testset "Maze Visualization" begin
    simple_maze = maze(3, 3)
    @test typeof(simple_maze.visual) == MazeViz
  end
end
