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
