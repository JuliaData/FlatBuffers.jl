
# FlatBuffers

*A Julia implementation of google flatbuffers*

| **Documentation**                                                               | **PackageEvaluator**                                            | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:---------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-latest-img]][docs-latest-url] | [![][pkg-0.4-img]][pkg-0.4-url] [![][pkg-0.5-img]][pkg-0.5-url] | [![][travis-img]][travis-url] [![][appveyor-img]][appveyor-url] [![][codecov-img]][codecov-url] |


## Installation

The package is registered in `METADATA.jl` and so can be installed with `Pkg.add`.

```julia
julia> Pkg.add("FlatBuffers")
```

## Documentation

- [**STABLE**][docs-stable-url] &mdash; **most recently tagged version of the documentation.**
- [**LATEST**][docs-latest-url] &mdash; *in-development version of the documentation.*

## Project Status

The package is tested against Julia `0.4` and *current* `0.5-dev` on Linux, OS X, and Windows.

## Contributing and Questions

Contributions are very welcome, as are feature requests and suggestions. Please open an
[issue][issues-url] if you encounter any problems or would just like to ask a question.



[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://dmbates.github.io/FlatBuffers.jl/latest

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://dmbates.github.io/FlatBuffers.jl/stable

[travis-img]: https://travis-ci.org/dmbates/FlatBuffers.jl.svg?branch=master
[travis-url]: https://travis-ci.org/dmbates/FlatBuffers.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/h227adt6ovd1u3sx/branch/master?svg=true
[appveyor-url]: https://ci.appveyor.com/project/dmbates/documenter-jl/branch/master

[codecov-img]: https://codecov.io/gh/dmbates/FlatBuffers.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/dmbates/FlatBuffers.jl

[issues-url]: https://github.com/dmbates/FlatBuffers.jl/issues

[pkg-0.4-img]: http://pkg.julialang.org/badges/FlatBuffers_0.4.svg
[pkg-0.4-url]: http://pkg.julialang.org/?pkg=FlatBuffers
[pkg-0.5-img]: http://pkg.julialang.org/badges/FlatBuffers_0.5.svg
[pkg-0.5-url]: http://pkg.julialang.org/?pkg=FlatBuffers

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

using FlatBuffers

type SimpleType
    x::Int32
end

@default SimpleType x=1

end
```

A couple of things to point out:
* `using FlatBuffers` was included near the top to bring in the FlatBuffers module; this defines the necessary FlatBuffers.jl machinery for making the schema definitions easier
* `int` translates to a Julia `Int32`, see more info on flatbuffer types [here](https://google.github.io/flatbuffers/md__schemas.html)
* A default value for the `x` field in `SimpleType` was declared after the type with the `@default` macro
* No `root_type` definition is necessary in Julia; basically any type defined with `type` (i.e. not abstract or immutable) can be a valid root table type in Julia.

So let's see how we can actually use a flatbuffer in Julia:

```julia
using FlatBuffers, Example # the schema module we defined above

val = Example.SimpleType(2) # create an instance of our type

flatbuffer = FlatBuffers.build!(val) # start and build a flatbuffer for our SimpleType
val2 = FlatBuffers.read(flatbuffer) # now we can deserialize the value from our flatbuffer, `val2` == `val`
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
* `@struct immutable T fields... end`: convenience macro for defining flatbuffer struct types, ensuring any necessary padding gets added to the type definition
