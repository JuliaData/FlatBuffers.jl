using FlatBuffers
using Test

# test default fields
@with_kw mutable struct UltimateAnswer
    answer::Int32 = 42
    question::String
    fishleft::UInt8 = 1
    highwaysbuilt::Int32 = 7
end

x = UltimateAnswer(;question="How many roads must a man walk down?")
@test x.answer == 42
@test FlatBuffers.default(UltimateAnswer, Int32, :answer) == 42
@test FlatBuffers.default(UltimateAnswer, UInt8, :fishleft) == 1
@test FlatBuffers.default(UltimateAnswer, Int32, :highwaysbuilt) == 7
b = FlatBuffers.Builder(UltimateAnswer)
FlatBuffers.build!(b, x)
xbytes = FlatBuffers.bytes(b)
y = FlatBuffers.read(UltimateAnswer, xbytes)

@test y.answer == x.answer
@test y.question == x.question
@test y.fishleft == x.fishleft
@test y.highwaysbuilt == x.highwaysbuilt