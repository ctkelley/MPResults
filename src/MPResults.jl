"""
MPResults

This module has the code you need for the mixed precision example.
"""
module MPResults

export
# Functions
heqtest,
mptest,
testiow,
testior,
PlotHist,
storehist,
readem,
htest,
htime,
hset

using PyPlot
using LinearAlgebra
using Printf
using SIAMFANLEquations
using SIAMFANLEquations.TestProblems
using SIAMFANLEquations.Examples

include("heqtest.jl")
include("mptest.jl")
include("testio.jl")
include("readem.jl")

end #module
