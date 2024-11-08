using Graphs: grid, kruskal_mst, src, dst, edges
using SparseArrays: sparse

"""
    random_maze(m, n)

Generate a random maze of size 2m+1 and 2n+1.

Returns a matrix of size `2m+1` by `2n+1` where a value of 1 indicates a wall and 0 a path.

The algorithm creates a maze by taking a grid graph of size `m x n`, assigning random edge weights and computing a minimum spanning tree. Entry and exit points are then added at the top left and bottom right of the maze.
"""
function random_maze(m::Int, n::Int)
    g = grid([m,n])
    I = [src.(edges(g)); dst.(edges(g))]
    J = [dst.(edges(g)); src.(edges(g))]
    val = rand(length(J))
    W = sparse(I, J, val)
    tree = kruskal_mst(g, W)
    M = ones(Int,2m+1,2n+1)
    M[2 .* (1:m), 2 .* (1:n)] .= 0
    for e in tree
        u, v = src(e), dst(e)
        i_u, j_u = grididx(u,m)
        i_v, j_v = grididx(v,m)
        M[i_u+i_v,j_u+j_v] = 0
    end
    M[2,1] = 0
    M[2m,2n+1] = 0
    return M
end

function grididx(k,n)
    i = rem(k-1,n) + 1
    j = div(k-1,n) + 1
    return i, j
end
