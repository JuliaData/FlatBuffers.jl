# automatically generated by the FlatBuffers compiler, do not modify

# module: Example

import FlatBuffers

FlatBuffers.@with_kw mutable struct TestSimpleTableWithEnum
    color::Int8 = 2
end
FlatBuffers.@ALIGN(TestSimpleTableWithEnum, 1)
FlatBuffers.offsets(::Type{T}) where {T<:TestSimpleTableWithEnum} = [
    0x00000004
]

function TestSimpleTableWithEnum(buf::AbstractVector{UInt8}, pos::Integer)
    FlatBuffers.read(TestSimpleTableWithEnum, buf, pos)
end
