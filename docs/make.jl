using Pkg
cd(@__DIR__)
Pkg.activate(".")
pkg"dev .."
Pkg.precompile()

using JuliaFractals
using Documenter

Documenter.DocMeta.setdocmeta!(
    JuliaFractals,
    :DocTestSetup,
    :(using JuliaFractals);
    recursive = true
)

makedocs(;
  modules = [JuliaFractals],
  doctest = true,
  linkcheck = true,
  authors = "Martin Malenický <malenicky.martin@gmail.com>",
  repo = "https://github.com/malenickymartin/JuliaFractals.jl/blob/{commit}{path}#{line}",
  sitename = "JuliaFractals.jl",
  format = Documenter.HTML(;
    prettyurls = get(ENV, "CI", false) == "true",
    canonical = "https://malenickymartin.github.io/JuliaFractals.jl",
  ),
  pages = ["Home" => "index.md", "Interactive App" => "app.md", "Reference" => "reference.md"],
)

deploydocs(; repo = "github.com/malenickymartin/JuliaFractals.jl", push_preview = false)