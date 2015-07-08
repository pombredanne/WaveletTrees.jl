type WaveletTree2D
	lowpass::Matrix
	highpass::Array{Any,1}
end


function WaveletTree2D(levels::Integer, size::Tuple{Integer,Integer}; D::Integer=3)
	W = cell(levels)

	for level = 0:levels-1
		W[level+1] = cell(D)
		for dir = 1:D
			W[level+1][dir] = Array(Float64, size[1]*2^level, size[2]*2^level)
		end
	end

	WaveletTree2D(W[1][1], W)
end


import Base.show
function show(io::IO, W::WaveletTree2D)
	println(io, "Lowpass:")
	show(io, W.lowpass)
	print(io, "\n\n")

	numberof_levels = length(W.highpass)
	for level = 1:numberof_levels
		str = string("Highpass level ", level, ":")
		println(io, str)
		show(io, W.highpass[level])
		print(io, "\n\n")
	end
end

import Base.size
@doc """
	size(WaveletTree2D)

A vector with the size of each subband.
"""->
function size(W::WaveletTree2D)
	highpass_count = length(W.highpass)
	subband_sizes = Array(Integer, highpass_count + 1, 2)

	subband_sizes[1,:] = [size(W.lowpass)...]

	for level = 1:highpass_count
		subband_sizes[level+1,:] = [size( W.highpass[level][1] )...]
	end

	return subband_sizes
end


function children_index(dims::Vector)
	#=
	The children of a coefficient are in the 2-by-2 block in the same
	position at one level higher. That is, the children of
	1 3 
	2 4
	are
	1 1 3 3
	1 1 3 3
	2 2 4 4 
	2 2 4 4 

	Within each block the coefficients are ordered column-wise.
	The coefficients are extracted by creating the index matrix
	1 3  9 11
	2 4 10 12
	5 7 13 15
	6 8 14 16
	=#

	numberof_parents = prod(dims)
	parent_indices = reshape( [1:numberof_parents;], dims[1], dims[2] )

	all_ones = ones(Integer,2,2)
	children_parent_relation = kron( parent_indices, all_ones )
	offset = 4*(children_parent_relation - 1)

	one_through_four = [1 3 ; 2 4]
	replicate_one_through_four = repmat( one_through_four, dims[1], dims[2] )

	cindex = offset + replicate_one_through_four
end


import Base.vec
@doc """
	vec(WaveletTree2D, level, D)

Return the coefficients on level `level` and direction `D` in `WaveletTree2D` 
as a vector sorted by affiliation to the parent node.
For a 4-by-4 subband the order is

	1 3  9 11
	2 4 10 12
	5 7 13 15
	6 8 14 16
"""->
function vec(W::WaveletTree2D, level::Integer, D::Integer)
	numberof_levels = length( W.highpass )
	if level < 1 || level > numberof_levels
		error("Level must be between 1 and ", numberof_subbands)
	end

	if level == 1
		return vec( W.highpass[1][D] )
	end

	sizes = size(W)
	dims = vec( sizes[level,:] )
	cindex = children_index(dims)

	return W.highpass[level][D][ cindex ]
end

