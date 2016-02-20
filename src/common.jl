@doc """
	WaveletTree{D}

Wavelet tree for `D` dimensional data.
"""->
type WaveletTree{D}
	lowpass::Array{Float64,D}
	highpass::Array{Any,1}
end

function show(io::IO, W::WaveletTree)
	println(io, "Lowpass:")
	show(io, W.lowpass)
	print(io, "\n\n")

	numberof_levels = levels(W)
	for level = 1:numberof_levels
		str = string("Highpass level ", level, ":")
		println(io, str)
		show(io, W.highpass[level])
		print(io, "\n\n")
	end
end


@doc """
	levels(W::WaveletTree)

Return the number of levels in `W`.
"""->
function levels(W::WaveletTree)
	return length(W.highpass)
end

@doc """
	size(WaveletTree, S::Char)

A vector with the size of each subband.
`S` indicates the subbands requested and can be one of

- `L`: Only low pass.
- `H`: Only high pass.
- `A` (default): Both low and high pass, in that order.
"""->
function size(W::WaveletTree, S::Char='A')
	if S == 'L'
		return size(W, Val{'L'})
	elseif S == 'H'
		return size(W, Val{'H'})
	elseif S == 'A'
		return [ size(W, Val{'L'})'; size(W, Val{'H'}) ]
	else
		throw(ArgumentError("Wrong subband requested"))
	end
end

function Base.(:(==)){D}(W1::WaveletTree{D}, W2::WaveletTree{D})
	W1.lowpass == W2.lowpass && W1.highpass == W2.highpass
end

