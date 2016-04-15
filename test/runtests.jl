using FlatBuffers
using Base.Test

include("monster.jl")

data_path = joinpath(dirname(@__FILE__), "monsterdata.bin")
if isreadable(data_path)
    println("testing ", data_path)
    buf = IOBuffer(Mmap.mmap(data_path))
    mm = Monster(buf, read(buf, Int32))
    @test mm[:hp] == 300
    @test mm[:mana] == 150
    @test mm[:friendly] == false
    @test Color(mm[:color]) == Blue
    @test mm[:weapons] == Weapon[]
end
