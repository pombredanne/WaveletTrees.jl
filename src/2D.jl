type WaveletMatrix
	lowpass::Matrix
	highpass::Array{Any,1}
end

@doc """
	wavelettree(levels::Integer, size::Tuple{Integer,Integer}, D::Integer=3)

Initialize a 2D WaveletTree with `levels` levels and the coarsest level as a matrix of size `size`.
Each highpass level has `D` subbands.

"""->
function wavelettree(levels::Integer, size::Tuple{Integer,Integer}, D::Integer=3)
	@assert levels >= 1 "There must be at least one level in the tree"
	@assert D >= 1 "There must be at least one direction"
	if D == 1
		warning("Are you sure you want a *2D* tree for 1D data?")
	end

	W = cell(levels)

	for level = 0:levels-1
		W[level+1] = cell(D)
		for dir = 1:D
			W[level+1][dir] = Array(Float64, size[1]*2^level, size[2]*2^level)
		end
	end

	return WaveletTree(W[1][1], W)
end

@doc """
	dirs(W::WaveletTree{D}) -> Int

The number of directions in the highpass subbands.
"""->
function dirs{D}(W::WaveletTree{D})
	if D == 1
		return 1
	else
		return length(W.highpass[1])
	end
end

function size(W::WaveletTree{2}, ::Type{Val{'L'}})
	[size(W.lowpass)...]
end

function size(W::WaveletTree{2}, ::Type{Val{'H'}})
	highpass_count = length(W.highpass)
	subband_sizes = Array(Integer, highpass_count, 2)

	for level = 1:highpass_count
		subband_sizes[level,:] = [size( W.highpass[level][1] )...]
	end

	return subband_sizes
end

@doc """
	cindex(dims::Tuple) -> Matrix

The *indices* of the children of a subband of size `dims`.

The children of a coefficient are the 2-by-2 block in the same position at one level finer. 
That is, the children of

	1 3 
	2 4

are

	1 1 3 3
	1 1 3 3
	2 2 4 4 
	2 2 4 4 

Within each block the coefficients are ordered column-wise.
Thus, the output of `cindex((2,2))` is

	1 3  9 11
	2 4 10 12
	5 7 13 15
	6 8 14 16
"""->
function cindex(dims::Tuple{Integer,Integer})
	N_parents = prod(dims)
	parent_indices = reshape( [1:N_parents;], dims[1], dims[2] )

	all_ones = ones(Integer,2,2)
	children_parent_relation = kron( parent_indices, all_ones )
	offset = 4*(children_parent_relation - 1)

	one_through_four = [1 3 ; 2 4]
	replicate_one_through_four = repmat( one_through_four, dims[1], dims[2] )

	cindex = offset + replicate_one_through_four
end


@doc """
	vec(WaveletTree, level, D)

Return the highpass coefficients on level `level` and direction `D` in a 2D `WaveletTree` as a vector sorted by affiliation to the parent node.
For a 4-by-4 subband the order is

	1 3  9 11
	2 4 10 12
	5 7 13 15
	6 8 14 16
"""->
function vec(W::WaveletTree{2}, level::Integer, D::Integer)
	@assert 1 <= level <= levels(W)

	if level == 1
		return vec( W.highpass[1][D] )
	end

	sizes = size(W)
	dims = ( sizes[level,:]... )
	children = cindex(dims)

	return W.highpass[level][D][ children ]
end

@doc """
	tree2mat(W::WaveletTree)

The `D` directional subbands on every level of `W` each with `N` coefficients are collected in a `D-by-N` matrix.

The ordering is such that the children of coefficient `n` on level `l` are `4n-3`, `4n-2`, `4n-1` and `4n` on level `l+1`.
"""->
function tree2mat(W::WaveletTree{2})
	L = levels(W)
	D = length(W.highpass[1])

	matrices = cell(L)
	subband_size = size(W)
	N_wave = prod(subband_size, 2)

	for l = 1:L
		matrices[l] = Array(Float64, D, N_wave[l+1])
		current_size = tuple( subband_size[l,:]... )

		if l == 1
			index = 1:N_wave[2]
		else
			index = cindex( (subband_size[l,:]...) )
		end

		for d = 1:D
			matrices[l][d,:] = W.highpass[l][d][index]
		end
	end

	return WaveletMatrix( W.lowpass, matrices )
end

@doc """
	mat2tree(W::WaveletMatrix)

The inverse of `tree2mat`.
"""->
function mat2tree(W::WaveletMatrix)
	L = length(W.highpass)
	D = size(W.highpass[1], 1)

	WW = wavelettree(L, size(W.lowpass), D)
	WW.lowpass = W.lowpass

	subband_size = size(WW)

	for l = 1:L
		for d = 1:D
			current_size = tuple( subband_size[l+1,:]... )
			WW.highpass[l][d] = reshape( W.highpass[l][d,:], current_size )
		end
	end

	return WW
end

