module FlatBuffers

"""
    Table

Concrete table types are subtypes of this abstract type.
They must include members of the form

    io::FlatBuffers.TableIO
    [memb::FlatBuffers.Membrs]({ref})
"""
abstract Table

"""
     jtypes

A `Vector{DataType}` of the Julia types `T <: Number` that are allowed in FlatBuffers schema
"""
const jtypes = [Bool, Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64, Float32, Float64]

"""
    Membrs

A type alias for the type of Dictionary in which the members of a  [`Table`]({ref})
are declared.  The three elements of the Tuple are the vtable offset (`Int16`), the
`DataType` of the member and a default value.
"""
typealias Membrs Dict{Symbol, Tuple{Int16, Union{DataType,Union}, Any}}

""""
    TableIO

The IO object containing the flatbuffer and positional information specific to the table.
The `vtable` containing the offsets for specific members precedes `pos`.
The actual values in the table follow `pos`.  `voff` and `vsz` are cached
offset and size of the vtable.

- `io::IO`: the flatbuffer itself
- `pos::Integer`:  the base position in `io` of the table
- `voff::Int32`: cached value of `read(seek(io, pos), Int32)`
- `vsz::Int16`: cached value of `read(seek(io, pos - voff), Int16)`
"""
type TableIO
    io::IO
    pos::Integer
    voff::Int32
    vsz::Int16
end

function TableIO(io::IO, pos)
    voff = read(seek(io, pos), Int32)
    TableIO(io, pos, voff, read(seek(io, pos - voff), Int16))
end

Base.seek(tio::TableIO, o) = seek(tio.io, tio.pos + o)

offset(tio::TableIO, vto) =
    vto < tio.vsz ? read(seek(tio, vto - tio.voff), Int16) : Int16(0)

veclen(tio::TableIO, o) = read(seek(tio, o + read(seek(tio, o), Int32)), Int32)

vector(tio::TableIO, o) = o + read(seek(tio, o), Int32)

indirect(tio::TableIO, o) = o + read(seek(tio, o), Int32)

"""
     tbl[sym]

Extract a member from a [`Table`]({ref})

Args:

- `tbl`: a [`FlatBuffers.Table`](`ref`)
- `sym`: a `Symbol`

Returns:
  The value of the member named `sym`

Throws:
  `Base.BoundsError` is the member table for `tbl` does not have a key `sym`.
"""
function Base.getindex(tbl::Table, sym::Symbol)
    vto, T, default = tbl.memb[sym]
    tio = tbl.io
    if (o = offset(tio, vto)) == 0
        return convert(T, default)
    end
    if T ∈ jtypes
        read(seek(tio, o), T)
    elseif T <: Array
        ndims(T) == 1 || throw(TypeError("Array table members must be one dimensional"))
        eT = eltype(T)
        vl = veclen(tio, o)
        vp = vector(tio, o)
        [eT(tio.io, tio.pos + indirect(tio, vp + i * sizeof(Int32))) for i in 1:vl]
    elseif T <: AbstractString
        o = read(seek(tio, o), Int32)
        strlen = read(seek(tio, o), Int32)
        T(readbytes(seek(tio, o + sizeof(Int32)), strlen))
    elseif T <: Table
        T(tio.io, tio.pos + indirect(tio, o))
    else
        error("Unknown constructor for type $T")
    end
end

end
