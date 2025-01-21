module SPJFractals

using GLMakie
using Base.Threads
using CUDA
using FLoops
using FoldsThreads

include("compute.jl")
include("fractal_equations.jl")

export compute_fractal, fractal_closure
export mandelbrot_equation, juliaset_equation

end # module SPJFractals
