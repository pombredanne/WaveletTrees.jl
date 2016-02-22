using WaveletTrees
using Base.Test

# Number of coarsest coefficients
Ncoef = 4

# A tree with zero levels
@test_throws AssertionError wavelettree(0,Ncoef)

Nlevels = 2
T1 = wavelettree(Nlevels, Ncoef)

# Test sizes
@test size(T1, 'L') == Ncoef
S = size(T1)
@test S[1] == S[2]
@test S[3] == 2*S[2]
@test_throws ArgumentError size(T1, 'G')

@test levels(T1) == Nlevels

@test dirs(T1) == 1

