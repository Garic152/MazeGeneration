module MazeVizModule
using ..MazeModule: Maze, MazeViz
using ..NodeModule: Node
using Match
export visualize_maze


function visualize_maze(maze::Maze)::MazeViz     #wir machen die Visualisierung mit ASCII-Symbolen, deswegen ist der Output ein String

    height, width = size(maze.nodes)                # nehme die Parameter aus dem struct Maze
    
    output_list = Matrix{Union{Nothing, String}}(nothing, 2*height + 1 , 2*width + 1)
    output_list[1,1] = " ┌─"
    output_list[2*height + 1, 1] = " └─"
    output_list[1, 2*width + 1] = "─┐ "
    output_list[2*height + 1 , 2*width + 1] = "─┘ "
    output_list[1,:] .= "───"
    output_list[2*height + 1,:] .= "───"
    output_list[:,1] .= " | "
    output_list[:,2*width + 1] .= " | "

    # Für die Lösung
    position_list = []
    for node in maze.path
        push!(position_list, (node.position))
    end

    for i in 1:height
        for j in 1:width
            
            if [i,j] in position_list
                output_list[2 * i, 2 * j] = " + "
                node = maze.nodes[i, j]         # right, bottom, left, top
                if node.neighbors[1] !== nothing
                    if [i, j + 1] in position_list 
                        output_list[2*i, 2*j + 1] = " + "
                    else
                        output_list[2*i, 2*j + 1] = "   "
                    end
                end
                if node.neighbors[2] !== nothing
                    if [i + 1, j] in position_list 
                        output_list[2*i + 1, 2*j] = " + "
                    else
                        output_list[2*i + 1, 2*j] = "   "
                    end
                end
                if node.neighbors[3] !== nothing
                    if [i, j - 1] in position_list 
                        output_list[2*i, 2*j - 1] = " + "
                    else
                        output_list[2*i, 2*j - 1] = "   "
                    end
                end
                if node.neighbors[4] !== nothing
                    if [i - 1, j] in position_list 
                        output_list[2*i - 1, 2*j] = " + "
                    else
                        output_list[2*i - 1, 2*j] = "   "
                    end
                end
            else
                output_list[2*i, 2*j] = "   "
                node = maze.nodes[i, j]         # right, bottom, left, top
                if node.neighbors[1] !== nothing
                    output_list[2*i, 2*j + 1] = "   "
                end
                if node.neighbors[2] !== nothing
                    output_list[2*i + 1, 2*j] = "   "
                end
                if node.neighbors[3] !== nothing
                    output_list[2*i, 2*j - 1] = "   "
                end
                if node.neighbors[4] !== nothing
                    output_list[2*i - 1, 2*j] = "   "
                end
            end
        end
    end

    
    for i in 1:2*height+1
        for j in 1:2*width+1
            if i % 2 == 0 && j % 2 == 0
                continue
            end
            if output_list[i, j] == "   " || output_list[i, j] == " + "
                continue
            end
            possible_neighbors = get_possible_neighbors(output_list, i, j)
            output_list[i, j] = choose_right_edge(possible_neighbors)
            
        end
    end
    
    for i in 1:height
        for j in 1:width

        end
    end
    output_list[2 * maze.start.position[1], 2 * maze.start.position[2]] = " ⁕ "
    output_list[2 * maze.goal.position[1], 2 * maze.goal.position[2]] = " ⛿ "



    output = ""
    for i in 1:2*height+1
        for j in 1:2*width+1
            output *= output_list[i, j]
        end
        output *= "\n"
    end

    viz = MazeViz(output)
    return viz
end


function get_possible_neighbors(list::Matrix{Union{Nothing, String}}, i::Int, j::Int)::Vector{Int}
    height, width = size(list)

    possible_neighbors = [1,1,1,1]          
    if i > 1
        if list[i - 1, j] !== "   " && list[i - 1, j] !== " + " # top ceiling
            possible_neighbors[4] = 0
        end
    end
    if i < height
        if list[i + 1, j] !== "   " && list[i + 1, j] !== " + "   # bottom ceiling
            possible_neighbors[2] = 0
        end
    end
    if j > 1
        if list[i, j - 1] !== "   " && list[i, j - 1] !== " + "    # left ceiling
            possible_neighbors[3] = 0
        end
    end
    if j < width 
        if list[i, j + 1] !== "   " && list[i, j + 1] !== " + "      # right ceiling
            possible_neighbors[1] = 0
        end
    end            

    return possible_neighbors 
end


function choose_right_edge(possible_neighbors::Vector{Int})::String
# ─ | ┌ └ ┐ ┘ ├ ┤ ┬ ┴ ╴ ╵ ╶ ╷
# right, bottom, left, top
    str = @match possible_neighbors begin
        [0,0,0,0] => "─┼─"
        [0,0,0,1] => "─┬─"
        [0,0,1,0] => " ├─"
        [0,0,1,1] => " ┌─"
        [0,1,0,0] => "─┴─"
        [0,1,0,1] => "───"
        [0,1,1,0] => " └─"
        [0,1,1,1] => "───"
        [1,0,0,0] => "─┤ "
        [1,0,0,1] => "─┐ "
        [1,0,1,0] => " │ "
        [1,0,1,1] => " ╷ "
        [1,1,0,0] => "─┘ "
        [1,1,0,1] => "── "
        [1,1,1,0] => " ╵ "
        [1,1,1,1] => "   "
    end

    return str    
end

function show_path(path::Vector{Node}, list::Matrix{Union{Nothing, String}})
    print()
end

function Base.show(io::IO, maze::Maze)
    viz = visualize_maze(maze)
    print(io, viz.visual)
end

end
