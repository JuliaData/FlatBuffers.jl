using FlatBuffers
using Base.Test

include("monster.jl")

data_path = joinpath(dirname(@__FILE__), "monsterdata.bin")
if isreadable(data_path)
    println("testing ", data_path)
    mm = FlatBuffers.getAsRoot(IOBuffer(Mmap.mmap(data_path)), Monster)
    @test mm[:hp] == 300
    @test mm[:mana] == 150
    @test mm[:friendly] == false
    @test Color(mm[:color]) == Blue
    @test mm[:weapons] == Weapon[]
end
