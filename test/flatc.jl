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

mon = open(joinpath(@__DIR__, "monsterdata_test.mon"), "r") do f read(f) end
rootpos = FlatBuffers.readbuffer(mon, 0, Int32)
monster = FlatBuffers.read(Monster{Any_}, mon, rootpos)

@test monster.hp == 80
@test monster.mana == 150
@test monster.name == "MyMonster"

vec = monster.pos

@test vec.x == 1.0
@test vec.y == 2.0
@test vec.z == 3.0
@test vec.test1 == 3.0
@test vec.test2 == 2

# t = vec.test3

# @test t.A == 5
# @test t.B == 6

# initialize a Table from a union field Test(...)
monster2 = monster.test

# initialize a Monster from the Table from the union

@test monster2.name == "Fred"

# iterate through the first monster's inventory:
@test length(monster.inventory) == 5

@test sum(monster.inventory) == 10
