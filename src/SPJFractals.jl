module SPJFractals

using GLMakie
using Base.Threads
using CUDA
using FLoops
using FoldsThreads
using Symbolics

include("compute.jl")
include("visualize.jl")
include("fractal_equations.jl")

export compute_fractal, fractal_closure
export mandelbrot_equation, julia_equation, burningship_equation, tricorn_equation, create_newton_equation
export basic_plot, fractal_app

end # module SPJFractals
