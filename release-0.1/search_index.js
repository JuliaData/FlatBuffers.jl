var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#FlatBuffers.jl-Documentation-1",
    "page": "Home",
    "title": "FlatBuffers.jl Documentation",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#Usage-1",
    "page": "Home",
    "title": "Usage",
    "category": "section",
    "text": "FlatBuffers.jl provides native Julia support for reading and writing binary structures following the google flatbuffer schema (see here for a more in-depth reveiw of the binary format).The typical language support for flatbuffers involves utilizing the flatc compiler to translate a flatbuffer schema file (.fbs) into a langugage-specific set of types/classes and methods. See here for the official guide on writing schemas.Currently in Julia, the flatc compiler isn't supported, but FlatBuffers.jl provides a native implementation of reading/writing the binary format directly with native Julia types. What does this mean exactly? Basically you can take a schema like:namespace example;\n\ntable SimpleType {\n  x: int = 1;\n}\n\nroot_type SimpleType;and do a straightforward Julia translation like:module Example\n\nusing FlatBuffers\n\ntype SimpleType\n    x::Int32\nend\n\n@default SimpleType x=1\n\nendA couple of things to point out:using FlatBuffers was included near the top to bring in the FlatBuffers module; this defines the necessary FlatBuffers.jl machinery for making the schema definitions easier\nint translates to a Julia Int32, see more info on flatbuffer types here\nA default value for the x field in SimpleType was declared after the type with the @default macro\nNo root_type definition is necessary in Julia; basically any type defined with type (i.e. not abstract or immutable) can be a valid root table type in Julia.So let's see how we can actually use a flatbuffer in Julia:using FlatBuffers, Example # the schema module we defined above\n\nval = Example.SimpleType(2) # create an instance of our type\n\nflatbuffer = FlatBuffers.build!(val) # start and build a flatbuffer for our SimpleType\nval2 = FlatBuffers.read(flatbuffer) # now we can deserialize the value from our flatbuffer, `val2` == `val`For more involved examples, see the test suite here."
},

{
    "location": "index.html#Reference-1",
    "page": "Home",
    "title": "Reference",
    "category": "section",
    "text": "Documentation is included inline for each type/method, these can be accessed at the REPL by type ?foo where foo is the name of the type or method you'd like more information on.List of types/methods:FlatBuffers.Table{T}: type for deserializing a Julia type T from a flatbuffer\nFlatBuffers.Builder{T}: type for serializing a Julia type T to a flatbuffer\nFlatBuffers.read: performs the actual deserializing on a FlatBuffer.Table\nFlatBuffers.build!: performs the actual serializing on a FlatBuffer.Builder\n@align T size_in_bytes: convenience macro for forcing a flatbuffer alignment on the Julia type T to size_in_bytes\n@default T field1=val1 field2=val2 ...: convenience macro for defining default field values for Julia type T\n@union T Union{T1,T2,...}: convenience macro for defining a flatbuffer union type T\n@struct immutable T fields... end: convenience macro for defining flatbuffer struct types, ensuring any necessary padding gets added to the type definition"
},

]}
