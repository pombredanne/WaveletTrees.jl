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

