using FlatBuffers
using Test
import Parameters

# test default fields
@with_kw mutable struct UltimateAnswer
    answer::Int32 = 42
    question::String
    message::String = "So long, and thanks for all the fish."
    highwaysbuilt::Int32 = 7
end

x = UltimateAnswer(;question="How many roads must a man walk down?")
@test x.answer == 42
@test FlatBuffers.default(UltimateAnswer, Int32, :answer) == 42
@test FlatBuffers.default(UltimateAnswer, String, :message) == "So long, and thanks for all the fish."
@test FlatBuffers.default(UltimateAnswer, Int32, :highwaysbuilt) == 7
b = FlatBuffers.Builder(UltimateAnswer)
FlatBuffers.build!(b, x)
xbytes = FlatBuffers.bytes(b)
y = FlatBuffers.read(UltimateAnswer, xbytes)

@test y.answer == x.answer
@test y.question == x.question
@test y.message == x.message
@test y.highwaysbuilt == x.highwaysbuilt
@test x.highwaysbuilt == 7
@test x.message == "So long, and thanks for all the fish."

y = Parameters.reconstruct(x, highwaysbuilt = 0)
b = FlatBuffers.Builder(UltimateAnswer)
FlatBuffers.build!(b, y)
ybytes = FlatBuffers.bytes(b)

# check that we save bytes with default integer values
@test length(ybytes) == length(xbytes) + 4

@test y.answer == x.answer
@test y.question == x.question
@test y.message == x.message
@test y.highwaysbuilt == 0

y = FlatBuffers.read(UltimateAnswer, ybytes)
@test y.highwaysbuilt == 0

# check that we save bytes with string default values
z = Parameters.reconstruct(x, message="No worries.")
b = FlatBuffers.Builder(UltimateAnswer)
FlatBuffers.build!(b, z)
zbytes = FlatBuffers.bytes(b)

z = FlatBuffers.read(UltimateAnswer, zbytes)
@test z.message == "No worries."

@test length(zbytes) > length(xbytes)
