module WaveletTrees

import Base: show, size, vec

include("1D.jl")
include("2D.jl")

# package code goes here
export # types
	WaveletTree1D,
	WaveletTree2D,
	WaveletMatrix2D,

	# functions
	size,
	levels,
	vec,
	children_index,
	tree2mat,
	mat2tree

end # module
