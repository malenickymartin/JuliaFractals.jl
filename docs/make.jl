using Pkg
cd(@__DIR__)
Pkg.activate(".")
pkg"dev .."
Pkg.precompile()

using SPJFractals
using Documenter: Documenter

DocMeta.setdocmeta!(
    SPJFractals,
    :DocTestSetup,
    :(using SPJFractals);
    recursive = true
)

makedocs(;
  modules = [SPJFractals],
  doctest = true,
  linkcheck = true,
  authors = "Martin Malenický <malenicky.martin@gmail.com>",
  repo = "https://github.com/malenickymartin/SPJFractals.jl/blob/{commit}{path}#{line}",
  sitename = "SPJFractals.jl",
  format = Documenter.HTML(;
    prettyurls = get(ENV, "CI", false) == "true",
    canonical = "https://malenickymartin.github.io/SPJFractals.jl",
  ),
  pages = ["Home" => "index.md", "Interactive App" => "app.md", "Reference" => "reference.md"],
)

deploydocs(; repo = "github.com/malenickymartin/SPJFractals.jl", push_preview = false)