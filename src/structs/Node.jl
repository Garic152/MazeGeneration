module NodeModule
export Node, neighbors

struct Node
  position::Vector{Int}                   # position: height, width
  neighbors::Array{Union{Node, Nothing}} # left, right, top, bottom child
end

function neighbors(node::Node)
  neighbors = []
  for neighbor in node.neighbors
    if neighbor != nothing
      push!(neighbors, neighbor)
    end
  end
  return neighbors
end

end
