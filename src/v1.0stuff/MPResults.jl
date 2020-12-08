"""
MPResults

This module has the code you need for the mixed precision example.
"""
module MPResults

export nsold01
export heqtest
export plotnsold
export fprintTeX
export data_populate
export data_harvest


using PyPlot
using LinearAlgebra
using JLD2
using Printf

include("Heq4nsold.jl")
include("nsoldv01.jl")
include("heqtest.jl")
include("plotnsold.jl")
include("fprintTeX.jl")
include("data_populate.jl")
include("data_harvest.jl")
#include("tabulatensold.jl")

using .Heq4nsold

end
