module MazeSolverModule
export solve

using ..NodeModule
using ..MazeModule
using ..MazeVizModule

function it!(node::Node, current_neighbor::Int, goal::Node)::Vector{Node}
    if node.position == goal.position
        return [node]
    end
    for i = 0:3
        neighbor = node.neighbors[(current_neighbor+i)%4+1]
        if neighbor !== nothing
            x = it!(neighbor, (current_neighbor + 1) % 4 + 1, goal)
            if x == []
                continue
            else
                return [node; x]
            end
        else
            continue
        end
    end
    return []
end

function solve(maze::Maze)::Vector{Node}
    solution = it!(maze.start, 1, maze.goal)
    return solution
end


# function next_move(node::Node, visited::Set{Node})::Union{Node,Nothing}
#     for neighbor in neighbors(node)
#         if neighbor !== nothing && !(neighbor in visited)
#             return neighbor
#         end
#     end
#     return nothing
# end
# 
# function solve(maze::Maze, start::Node, goal::Node)::Vector{Node}
#     path = []
#     visited = Set{Node}()
#     current = start
#     push!(path, current)
#     push!(visited, current)
# 
#     while current != goal
#         next_node = next_move(current, visited)
#         if next_node !== nothing
#             push!(path, next_node)
#             push!(visited, next_node)
#             current = next_node
#         else
#             pop!(path)
#             if isempty(path)
#                 error("No path found from start to goal")
#             end
#             current = path[end]
#         end
#     end
#     maze.path = path
#     return path
# end

end
