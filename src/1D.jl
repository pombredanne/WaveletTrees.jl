@doc """
	WaveletTree(levels::Integer, size::Integer) -> WaveletTree{1}

Initialize a 1D wavelet tree with `levels` levels and the coarsest level with `size` coefficients.
"""->
function WaveletTree(levels::Integer, size::Integer)
	W = cell(levels)
	for l = 0:levels-1
		W[l+1] = Array(Float64, size*2^l)
	end

	WaveletTree{1}(W[1], W)
end


@doc """
	size(WaveletTree{1}; S::Char)

A vector with the size of each subband.
`S` indicates the subbands requested and can be one of

- `L`: Only low pass.
- `H`: Only high pass.
- `A` (default): Both low and high pass, in that order.
"""->
function size(W::WaveletTree{1}, S::Char='A')
	if S == 'L'
		return size(W, Val{'L'})
	elseif S == 'H'
		return size(W, Val{'H'})
	elseif S == 'A'
		return [ size(W, Val{'L'}); size(W, Val{'H'}) ]
	else
		error("Wrong subband requested")
	end
end

function size(W::WaveletTree{1}, ::Type{Val{'L'}})
	length(W.lowpass)
end

function size(W::WaveletTree{1}, ::Type{Val{'H'}})
	L = length(W.highpass)
	subband_sizes = Array(Integer, L)

	for l = 1:L
		subband_sizes[l] = length( W.highpass[l] )
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
