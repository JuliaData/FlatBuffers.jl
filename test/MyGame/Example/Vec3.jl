# automatically generated by the FlatBuffers compiler, do not modify

# module: Example

import FlatBuffers

FlatBuffers.@STRUCT struct Vec3
    x::Float32
    y::Float32
    z::Float32
    test1::Float64
    test2::Color
    test3::Test
end
FlatBuffers.@ALIGN(Vec3, 16)

Vec3(buf::AbstractVector{UInt8}) = FlatBuffers.read(Vec3, buf)
Vec3(io::IO) = FlatBuffers.deserialize(io, Vec3)
