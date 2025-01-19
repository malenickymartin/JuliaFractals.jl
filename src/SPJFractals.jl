module SPJFractals

using GLMakie
using Base.Threads
using CUDA

include("compute.jl")
include("fractal_equations.jl")

export compute_fractal

end # module SPJFractals
