using Documenter, FlatBuffers

makedocs(;
    modules=[FlatBuffers],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/JuliaData/FlatBuffers.jl/blob/{commit}{path}#L{line}",
    sitename="FlatBuffers.jl",
    assets=String[],
)

deploydocs(;
    repo="github.com/JuliaData/FlatBuffers.jl",
    devbranch = "main"
)
