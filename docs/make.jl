using Documenter, FlatBuffers

makedocs(;
    modules=[FlatBuffers],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo=Documenter.Remotes.GitHub("JuliaData", "FlatBuffers.jl"),
    sitename="FlatBuffers.jl",
)

deploydocs(;
    repo="github.com/JuliaData/FlatBuffers.jl",
    devbranch = "main"
)
