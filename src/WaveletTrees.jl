module WaveletTrees

import Base: show, size, vec

include("common.jl")
include("1D.jl")
include("2D.jl")

# package code goes here
export 
	# types
	WaveletTree,
	WaveletMatrix,

	# functions
	size,
	levels,
	vec,
	cindex,
	tree2mat,
	mat2tree

end # module
