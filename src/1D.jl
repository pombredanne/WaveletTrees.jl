type WaveletTree1D
	lowpass::Vector
	highpass::Array{Any,1}
end

function WaveletTree1D(levels::Integer, size::Integer)
	W = cell(levels)
	for l = 0:levels-1
		W[l+1] = Array(Float64, size*2^l)
	end

	WaveletTree1D(W[1], W)
end


@doc """
	size(WaveletTree1D)

A vector with the size of each subband.
"""->
function size(W::WaveletTree1D)
	highpass_count = length(W.highpass)
	subband_sizes = Array(Integer, highpass_count + 1)

	subband_sizes[1] = length(W.lowpass)

	for level = 1:highpass_count
		subband_sizes[level+1] = length(W.highpass[level])
	end

	return subband_sizes
end

#=
@doc """
	parent(WaveletTree1D, level, index)

The parent of `index` on `level` is an index on `level-1`.
"""->
function parent(W::WaveletTree1D, level::Integer, index::Integer)
	numberof_subbands = length(W.highpass)
	if level <= 1 || level > numberof_subbands
		error("Level must be between 1 and ", numberof_subbands)
	end

	parent_index = ceil(Int, index/2)
end


@doc """
	child(WaveletTree1D, level, index)

The children of `index` on `level` are two indices on `level+1`.
"""->
function child(W::WaveletTree1D, level::Integer, index::Integer)
	numberof_subbands = length(W.highpass)
	if level >= numberof_subbands
		error("Level must be between 1 and ", numberof_subbands-1)
	end

	children_index = [2*index-1; 2*index]
end
=#
