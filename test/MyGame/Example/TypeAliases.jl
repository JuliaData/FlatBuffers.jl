# automatically generated by the FlatBuffers compiler, do not modify

# module: Example

import FlatBuffers

FlatBuffers.@with_kw mutable struct TypeAliases
    i8::Int8 = 0
    u8::UInt8 = 0
    i16::Int16 = 0
    u16::UInt16 = 0
    i32::Int32 = 0
    u32::UInt32 = 0
    i64::Int64 = 0
    u64::UInt64 = 0
    f32::Float32 = 0.0
    f64::Float64 = 0.0
    v8::Vector{Int8} = []
    vf64::Vector{Float64} = []
end
FlatBuffers.@ALIGN(TypeAliases, 1)
FlatBuffers.offsets(::Type{T}) where {T<:TypeAliases} = [4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26]

function TypeAliases(buf::Vector{UInt8}, offset::Integer)
    FlatBuffers.read(TypeAliases, buf, offset)
end

