module WaveletTrees

import Base: show, size, vec

include("1D.jl")
include("2D.jl")
include("common.jl")

# package code goes here
export # types
	WaveletTree1D,
	WaveletTree2D,
	WaveletTree,
	WaveletMatrix2D,

	# functions
	size,
	levels,
	vec,
	cindex,
	tree2mat,
	mat2tree

end # module
