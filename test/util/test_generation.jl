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
