using Test
import FlatBuffers

# generated code
include("MyGame/MyGame.jl")
import .MyGame
import .MyGame.Example
import .MyGame.Example2
import .MyGame.Example.Any_
import .MyGame.Example.Monster
import .MyGame.Example.TestSimpleTableWithEnum

# override the typeorder function, since we are working around
# circular type definitions using type parameters
FlatBuffers.typeorder(::Type{Any_}, i::Integer) = [Nothing, Monster{Any_}, TestSimpleTableWithEnum, Example2.Monster][i+1]

function loadmonsterfile(filename)
    mon = open(joinpath(@__DIR__, filename), "r") do f read(f) end
    return FlatBuffers.read(Monster{Any_}, mon)
end

function checkmonster(monster)
    @test monster.hp == 80
    @test monster.mana == 150
    @test monster.name == "MyMonster"

    vec = monster.pos

    @test vec.x == 1.0
    @test vec.y == 2.0
    @test vec.z == 3.0
    @test vec.test1 == 3.0
    @test vec.test2 == 2
    @test vec.test3_a == 5
    @test vec.test3_b == 6

    monster2 = monster.test
    @test monster2.name == "Fred"

    @test length(monster.inventory) == 5
    @test sum(monster.inventory) == 10

    @test monster.vector_of_longs == [10 ^ (2*i) for i = 0:4]
    @test monster.vector_of_doubles == [-1.7976931348623157e+308, 0, 1.7976931348623157e+308]

    @test length(monster.test4) == 2

    (test0, test1) = monster.test4
    @test sum([test0.a, test0.b, test1.a, test1.b]) == 100

    @test monster.testarrayofstring == ["test1", "test2"]
    @test monster.testarrayoftables == nothing
    @test monster.testf == 3.14159f0
end

function checkpassthrough(monster)
    b = FlatBuffers.Builder(Monster{Any_})
    FlatBuffers.build!(b, monster)
    bytes = FlatBuffers.bytes(b)
    newmonster = FlatBuffers.read(Monster{Any_}, bytes)
    checkmonster(newmonster)
end

@test FlatBuffers.file_identifier(Monster) == "MONS"
@test FlatBuffers.file_extension(Monster) == "mon"

for testcase in ["test", "python_wire"]
    mon = loadmonsterfile("monsterdata_$testcase.mon")
    checkmonster(mon)
    checkpassthrough(mon)
end

