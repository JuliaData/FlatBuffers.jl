# automatically generated by the FlatBuffers compiler, do not modify

# module: MyGame

import FlatBuffers

mutable struct InParentNamespace
end
FlatBuffers.@ALIGN(InParentNamespace, 1)

function InParentNamespace(buf::AbstractVector{UInt8}, pos::Integer)
    FlatBuffers.read(InParentNamespace, buf, pos)
end
