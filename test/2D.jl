using WaveletTrees
using Base.Test

# Number of coarsest coefficients
Ncoef = (2,2)

# A tree with zero levels
@test_throws AssertionError wavelettree(0,Ncoef)

Nlevels = 2
T2 = wavelettree(Nlevels, Ncoef)

# Test sizes
@test size(T2, 'L') == [Ncoef...]
S = size(T2)
@test S[1,:] == S[2,:]
@test S[3,:] == 2*S[2,:]

@test levels(T2) == Nlevels
@test dirs(T2) == 3

@test T2 == mat2tree(tree2mat(T2))

# TODO: vec and cindex
# Test vec(torize)
children = kron( [1 3;2 4], ones(Integer,2,2) )
index = cindex( (2,2) )
expected = repmat( [1:4;]', 4, 1 )
@test children[index] == expected
