module FlatBuffers

"""
    Table

Concrete table types are subtypes of this abstract type.
They must include members of the form

    io::FlatBuffers.TableIO
    [memb::FlatBuffers.Membrs]({ref})
"""
abstract Table

typealias uoffset_t UInt32
typealias soffset_t  Int32
typealias voffset_t UInt16
typealias ScalarTypes  Union{Bool, Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64, Float32, Float64}

const FLATBUFFERS_MAX_BUFFER_SIZE = ((UInt64(1) << (sizeof(soffset_t) * 8 - 1)) - 1)

getAsRoot{T <: Table}(io::IO, ::Type{T}) = T(io, read(io, uoffset_t))

"""
    Membrs

A type alias for the type of Dictionary in which the members of a  [`Table`]({ref})
are declared.  The three elements of the Tuple are the vtable offset (`Int16`), the
`DataType` of the member and a default value.
"""
typealias Membrs Dict{Symbol, Tuple{voffset_t, Union{DataType,Union}, Any}}

""""
    TableIO

The IO object containing the flatbuffer and positional information specific to the table.
The `vtable` containing the offsets for specific members precedes `pos`.
The actual values in the table follow `pos`.  `voff` and `vsz` are cached
offset and size of the vtable.

- `io::IO`: the flatbuffer itself
- `pos::uoffset_t`:  the base position in `io` of the table
- `voff::soffset_t`: cached value of `read(seek(io, pos), soffset_t)`
- `vsz::voffset_t`: cached value of `read(seek(io, pos - voff), voffset_t)`
"""
type TableIO
    io::IO
    pos::uoffset_t
    voff::soffset_t
    vsz::voffset_t
end

function TableIO(io::IO, pos)
    voff = read(seek(io, pos), soffset_t)
    TableIO(io, uoffset_t(pos), voff, read(seek(io, pos - voff), voffset_t))
end

## FIXME: add Base.read method for user-declared isbits types (immutable with only bitstypes)
## FIXME: add method Base.read method for Unions
function Base.read{T <: AbstractString}(tio::TableIO, o::Integer, ::Type{T})
    o += read(seek(tio, o), Int32)
    len = read(seek(tio, o), Int32)
    T(readbytes(seek(tio, o + sizeof(Int32)), len))
end

## FIXME: not sure this will work in an array.  The int type is user-specified in the IDL
Base.read{T <: Enum}(tio::TableIO, o::Integer, ::Type{T}) = T(read(seek(tio, o), UInt32))

function Base.read{T}(tio::TableIO, o::Integer, ::Type{Array{T, 1}})
    o += read(seek(tio, o), UInt32)
    l = read(seek(tio, o), UInt32)
    [read(tio, o + i * sizeof(Int32), T) for i in 1:l]
end

Base.read{T <: ScalarTypes}(tio::TableIO, o::Integer, ::Type{T}) = read(seek(tio, o), T)

Base.read{T <: Table}(tio::TableIO, o::Integer, ::Type{T}) = T(tio.io, tio.pos + o)

Base.seek(tio::TableIO, o) = seek(tio.io, tio.pos + o)

"""
    contents(tbl)

Return the values actually stored in `tbl`

Args:

- `tbl`: a flatbuffers [`Table`]({ref})

Returns:
   a `Dict{Symbol, Any}` of the values actually stored in `tbl`
"""
function contents(tbl::Table)
    tio = tbl.io
    res = Dict{Symbol, Any}()
    for (k, v) in tbl.memb
        o = offset(tio, v[1])
        if o != 0
            res[k] = read(tio, o, v[2])
        end
    end
    res
end


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
    o = offset(tio, vto)
    o == 0 ? convert(T, default) : read(tio, o, T)
end

offset(tio::TableIO, vto) =
    vto < tio.vsz ? read(seek(tio, vto - tio.voff), voffset_t) : voffset_t(0)

veclen(tio::TableIO, o) = read(seek(tio, o + read(seek(tio, o), Int32)), Int32)

vector(tio::TableIO, o) = o + read(seek(tio, o), Int32)

indirect(tio::TableIO, o) = o + read(seek(tio, o), Int32)

end
