type WaveletTree1D
	lowpass::Vector
	highpass::Array{Any,1}
end

# Outer construction
#@doc """
#	WaveletTree1D(levels, size)
#
#Initiate `WaveletTree1D` with `levels` levels and `size` number of lowpass coefficients.
#"""->
function WaveletTree1D(levels::Integer, size::Integer)
	W = cell(levels)
	for l = 0:levels-1
		W[l] = Array(Float64, size*2^l)
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

