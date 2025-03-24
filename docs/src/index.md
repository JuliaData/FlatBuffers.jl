# FlatBuffers.jl Documentation

#### Overview
FlatBuffers.jl provides native Julia support for reading and writing binary structures following the google flatbuffer schema (see [here](https://google.github.io/flatbuffers/flatbuffers_internals.html) for a more in-depth review of the binary format).

The typical language support for flatbuffers involves utilizing the `flatc` compiler to translate a flatbuffer schema file (.fbs) into a langugage-specific set of types/classes and methods. See [here](https://google.github.io/flatbuffers/flatbuffers_guide_writing_schema.html) for the official guide on writing schemas.

This Julia package contains serialization primitives and a minimal set of macros which provide flatbuffer-compatible serialization of existing Julia types. This has led to the Julia code appearing somewhat more readable than for other languages.

For example, for this schema:
```
namespace example;

table SimpleType {
  x: int = 1;
}

root_type SimpleType;
```
the corresponding Julia looks like this:
```julia
module Example

using FlatBuffers
@with_kw mutable struct SimpleType
    x::Int32 = 1
end

# ... other generated stuff
end
```
You can pepper your existing Julia types with these macros and then call the functions below to produce flatbuffer-compatible
binaries.

#### Usage
`FlatBuffers` provides the following functions for reading and writing flatbuffers:
```
FlatBuffers.serialize(stream::IO, value::T) 
FlatBuffers.deserialize(stream::IO, ::Type{T})
```
These methods are not exported to avoid naming clashes with the `Serialization` module.
For convenience, there are also two additional constructors defined for each generated type:
* `T(buf::AbstractVector{UInt8}, pos::Integer=0)`
* `T(io::IO)`

Here is an example showing how to use them to serialize the example type above.
```julia
import FlatBuffers, Example

# create an instance of our type
val = Example.SimpleType(2)

# serialize it to example.bin
open("example.bin", "w") do f FlatBuffers.serialize(f, val) end

# read the value back again from file
val2 = open("example.bin", "r") do f
  FlatBuffers.deserialize(f, Example.SimpleType)
end
```
In addition, this package provides the following types and methods, which are useful
when inspecting and constructing flatbuffers:
* `FlatBuffers.Table{T}` - type for deserializing a Julia type `T` from a flatbuffer
* `FlatBuffers.Builder{T}` - type for serializing a Julia type `T` to a flatbuffer
* `FlatBuffers.read` - performs the actual deserializing on a `FlatBuffer.Table`
* `FlatBuffers.build!` - performs the actual serializing on a `FlatBuffer.Builder`

#### Additional Methods
For a type `T` it is also possible to define:
* `FlatBuffers.file_extension(T)` - returns the `file_extension` specified in the schema (if any)
* `FlatBuffers.file_identifier(T)` - returns the `file_identifier` specified in the schema (if any)
* `FlatBuffers.has_identifier(T, bytes)` - returns whether the given bytes contain the identifier for `T` at the offset designated by the flatbuffers specification
* `FlatBuffers.slot_offsets(T)` - an array containing the positions of the slots in the vtable for type `T`, accounting for gaps caused by deprecated fields
* `FlatBuffers.root_type(T)` - returns whether the type is designated as the root type by the schema. Also note however that no `root_type` definition is necessary in Julia; any of the generated `mutable struct`s can be a valid root table type.

#### State of flatc integration
It was hoped that support for Julia could be added to `flatc`, however this is difficult with the current approach due to 
https://github.com/JuliaLang/julia/issues/269. This package will require a rethink, or potentially a completely separate package may be created. The most up-to-date fork of `flatc` with support for Julia may be found here:
https://github.com/rjkat/flatbuffers-julia

#### Advanced utilities
Documentation is also included for many
internal methods and may be queried using `?` at the REPL.
* `@ALIGN T size_in_bytes` - convenience macro for forcing a flatbuffer alignment on the Julia type `T` to `size_in_bytes`
* `@with_kw mutable struct T fields...` - convenience macro for defining default field values for Julia type `T`
* `@UNION T Union{T1,T2,...}` - convenience macro for defining a flatbuffer union type `T`
* `@STRUCT struct T fields... end` - convenience macro for defining flatbuffer struct types, ensuring any necessary padding gets added to the type definition

## API

```@autodocs
Modules = [FlatBuffers]
```

### Base extensions

```@doc
Base.read
Base.prepend!
```
