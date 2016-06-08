# FlatBuffers

[![Build Status](https://travis-ci.org/dmbates/FlatBuffers.jl.svg?branch=master)](https://travis-ci.org/dmbates/FlatBuffers.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/04pfv59gtvkjimox/branch/master?svg=true)](https://ci.appveyor.com/project/dmbates/flatbuffers-jl/branch/master)

Package for reading/writing [Google flatbuffers](https://google.github.io/flatbuffers/index.html#flatbuffers_overview).

#### Installation

```julia
Pkg.add("FlatBuffers")
```

#### Usage

FlatBuffers.jl provides native Julia support for reading and writing binary structures following the google flatbuffer schema (see [here](https://google.github.io/flatbuffers/flatbuffers_internals.html) for a more in-depth reveiw of the binary format).

The typical language support for flatbuffers involves utilizing the `flatc` compiler to translate a flatbuffer schema file (.fbs) into a langugage-specific set of types/classes and methods. See [here](https://google.github.io/flatbuffers/flatbuffers_guide_writing_schema.html) for the official guide on writing schemas.

Currently in Julia, the `flatc` compiler isn't supported, but FlatBuffers.jl provides a native implementation of reading/writing the binary format directly with native Julia types. What does this mean exactly? Basically you can take a schema like:

```
namespace example;

table SimpleType {
  x: int = 1;
}

root_type SimpleType;
```

and do a straightforward Julia translation like:

```julia
module Example

include(joinpath(Pkg.dir("FlatBuffers"), "src/header.jl"))

type SimpleType
    x::Int32
end

@default SimpleType x=1

end
```

A couple of things to point out:
* An `include` call was included near the top of the Julia module to bring in the `header.jl` file; this is a utility file that defines the necessary FlatBuffers.jl machinery for making the schema definitions easier
* `int` translates to a Julia `Int32`, see more info on flatbuffer types [here](https://google.github.io/flatbuffers/md__schemas.html)
* A default value for the `x` field in `SimpleType` was declared after the type with the `@default` macro
* No `root_type` definition is necessary in Julia; basically any type defined with `type` (i.e. not abstract or immutable) can be a valid root table type in Julia.

So let's see how we can actually use a flatbuffer in Julia:

```julia
using FlatBuffers, Example # the schema module we defined above

val = Example.SimpleType(2) # create an instance of our type

flatbuffer = FlatBuffers.Builder(Example.SimpleType) # start a flatbuffer shell for our SimpleType
FlatBuffers.build!(flatbuffer, val) # serialize the flatbuffer using `val`
table = FlatBuffers.Table(flatbuffer) # the `Table` type is for reading, we can read a flatbuffer that's been built
val2 = FlatBuffers.read(table) # now we can deserialize the value from our flatbuffer, `val2` == `val`
```

For more involved examples, see the test suite [here](https://github.com/dmbates/FlatBuffers.jl/tree/master/test).

#### Reference

Documentation is included inline for each type/method, these can be accessed at the REPL by type `?foo` where `foo` is the name of the type or method you'd like more information on.

List of types/methods:

* `FlatBuffers.Table{T}`: type for deserializing a Julia type `T` from a flatbuffer
* `FlatBuffers.Builder{T}`: type for serializing a Julia type `T` to a flatbuffer
* `FlatBuffers.read`: performs the actual deserializing on a `FlatBuffer.Table`
* `FlatBuffers.build!`: performs the actual serializing on a `FlatBuffer.Builder`
* `@align T size_in_bytes`: convenience macro for forcing a flatbuffer alignment on the Julia type `T` to `size_in_bytes`
* `@default T field1=val1 field2=val2 ...`: convenience macro for defining default field values for Julia type `T`
* `@union T Union{T1,T2,...}`: convenience macro for defining a flatbuffer union type `T`
