using Distributions
using LinearAlgebra

"""
    random_orthogonal_matrix(n)

Generate a random orthogonal matrix of size `n`.

The generated matrices are uniformly distributed over the set of real orthogonal matrices.
"""
function random_orthogonal_matrix(n::Integer)
    A = randn(n,n)
    return qr(A).Q
end

"""
    random_symmetric_spectral(λ)

Generate a random symmetric matrix with eigenvalues `λ`.
"""
function random_symmetric_spectral(λ)
    Q = random_orthogonal_matrix(length(λ))
    return Symmetric(Q * Diagonal(λ) * Q')
end

function random_symmetric_spectral(d::UnivariateDistribution, n)
    λ = rand(d, n)
    return random_symmetric_spectral(λ)
end
