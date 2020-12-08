"""
MPResults

This module has the code you need for the mixed precision example.
"""
module MPResults

export
# Functions
heqtest,
PlotHist,
Fname,
data_harvest,
data_populate,
readmpdata,
writempdata,
MakeTable,
PlotData

using PyPlot
using LinearAlgebra
using Printf
using SIAMFANLEquations
using SIAMFANLEquations.TestProblems
using SIAMFANLEquations.Examples

include("heqtest.jl")
include("data_populate.jl")
include("Data_IO.jl")
include("PlotData.jl")
include("TableData.jl")

end #module
