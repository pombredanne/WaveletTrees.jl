# WaveletTrees

[![Build Status](https://travis-ci.org/robertdj/WaveletTrees.jl.svg?branch=master)](https://travis-ci.org/robertdj/WaveletTrees.jl)

This package contains data types I use for modelling wavelet trees.
A `WaveletTree` consists of a lowpass subband and (multiple) highpass subband(s); the highpass subband(s) are arranged in a tree structure.

For 1D signals the coefficients in the highpass subbands are arranged in a binary tree, i.e., a directed acyclic graph where each node has either zero or two children.
A binary tree with three levels are seen below.

![A binary wavelet tree](tree.png)

For 2D signals the highpass subbands *within each direction* are arranged in a quad tree, i.e., a tree where each node have either zero or four children.


# Types

The generic type available is `WaveletTree{D}`, where `D` denotes the dimension of the data prior to the wavelet transform and can be 1 or 2.
A `WaveletTree` has entries `lowpass` and `highpass` whose types depend on `D`.

A 1D `WaveletTree` with `L` levels and a lowpass/coarsest highpass subband with `size` coefficients are constructed with

```julia
WaveletTree(L, size)
```

and its entries are

- `lowpass`: 
A vector with `size` lowpass coefficients.
- `highpass`: 
A cell of `L` vectors with coefficients from each level, where `W.highpass[1]` is of length `size`.


A 2D `WaveletTree` with `L` levels, `D` directional subbands within each level and a lowpass subband (coarsest highpass) subband with `x-by-y` coefficients are constructed with

```julia
WaveletTree2D(L, (x,y), D)
```

(with default value `D = 3`) and its entries are

- `lowpass`: 
A matrix with `x-by-y` lowpass coefficients.
- `highpass`: 
A cell of `L` cells.
Each inner cell contains `D` matrices with coefficients from the directional subbands, where the matrices in `W.highpass[1]` are all `x-by-y` matrices.


# Functions

For `WaveletTree`s there are the functions

- `size`: Returns the number of coefficients in the lowpass subband, highpass subband or the two combined (which is the default). 
The result is either a vector or an `levels-by-2` matrix, depending on the dimension of `WaveletTree`.
- `levels`: The number of levels in the tree.

For 2D `WaveletTree`s there is furthermore 

- `vec`: Vectorizes a single directional subband according to the order induced by the parents `ρ`.
- `tree2mat`: The directional subbands on the same level are collected into one matrix.


# Acknowledgements

The layout with nested cells is inspired by the [contourlet toolbox](https://www.mathworks.com/matlabcentral/fileexchange/8837-contourlet-toolbox) for Matlab.

