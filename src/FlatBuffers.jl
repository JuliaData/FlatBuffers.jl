module FlatBuffers

abstract Table

const jtypes = [Bool, Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64, Float32, Float64]

Base.seek(tbl::Table, o) = seek(tbl.io, tbl.pos + o)

offset(tbl::Table, vto) = vto < tbl.vtblsz ? read(seek(tbl, vto - tbl.vtbloff), Int16) : zero(Int16)

veclen(tbl::Table, o) = read(seek(tbl, o + read(seek(tbl, o), Int32)), Int32)

vector(tbl::Table, o) = o + read(seek(tbl, o), Int32)

indirect(tbl::Table, o) = o + read(seek(tbl, o), Int32)

function Base.getindex(tbl::Table, sym::Symbol)
    vto, T, default = tbl.members[sym]
    if (o = offset(tbl, vto)) == 0
        default
    elseif T ∈ jtypes
        read(seek(tbl, o), T)
    elseif T <: Array
        ndims(T) == 1 || throw(TypeError("Array table members must be one dimensional"))
        eT = eltype(T)
        vl = veclen(tbl, o)
        vp = vector(tbl, o)
        [eT(tbl.io, tbl.pos + indirect(tbl, vp + i * sizeof(Int32))) for i in 1:vl]
    elseif T <: AbstractString
        o = read(seek(tbl, o), Int32)
        strlen = read(seek(tbl, o), Int32)
        T(readbytes(seek(tbl, o + sizeof(Int32)), strlen))
    elseif T <: Table
        T(tbl.io, tbl.pos + indirect(tbl, o))
    else
        error("Unknown constructor for type $T")
    end
end

end
