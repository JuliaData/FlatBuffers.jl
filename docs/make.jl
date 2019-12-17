import Pkg
Pkg.instantiate()
using Documenter, DocumenterMarkdown, FlatBuffers

makedocs(
    modules = [FlatBuffers],
    format = Documenter.HTML(),
    sitename = "FlatBuffers.jl",
    pages = ["Home" => "index.md"]
)

deploydocs(
    repo = "github.com/JuliaData/FlatBuffers.jl.git",
    target = "build",
    deps = nothing,
    make = nothing
)
