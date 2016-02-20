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

