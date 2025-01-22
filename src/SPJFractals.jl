module SPJFractals

using GLMakie
using Base.Threads
using CUDA
using FLoops
using FoldsThreads

include("compute.jl")
include("visualize.jl")
include("fractal_equations.jl")

export compute_fractal, fractal_closure
export mandelbrot_equation, julia_equation
export basic_plot

end # module SPJFractals
