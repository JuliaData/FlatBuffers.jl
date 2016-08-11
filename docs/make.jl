using Documenter, FlatBuffers

makedocs(
    modules = [FlatBuffers],
)

deploydocs(
    deps = Deps.pip("mkdocs", "python-markdown-math"),
    repo = "github.com/dmbates/FlatBuffers.jl.git"
)
