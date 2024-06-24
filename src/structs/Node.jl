module NodeModule
export Node, neighbors

struct Node
  position::Vector{Int}
  left_child::Union{Node,Nothing}
  right_child::Union{Node,Nothing}
  top_child::Union{Node,Nothing}
  bottom_child::Union{Node,Nothing}
end

function neighbors(node::Node)
  neighbors = []

  if node.left_child !== nothing
    push!(neighbors, node.left_child)
  end
  if node.right_child !== nothing
    push!(neighbors, node.right_child)
  end
  if node.top_child !== nothing
    push!(neighbors, node.top_child)
  end
  if node.bottom_child !== nothing
    push!(neighbors, node.bottom_child)
  end
  return neighbors
end

end
