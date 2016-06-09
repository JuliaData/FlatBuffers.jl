module Example
# Compat
if !isdefined(Core, :String)
    typealias String UTF8String
end

include(joinpath(Pkg.dir("FlatBuffers"), "src/header.jl"))

@enum(Color, Red = 0, Green = 1, Blue = 3)

immutable Test
    a::Int16
    b::UInt8
    _::UInt8 # padding
end

type TestSimpleTableWithEnum
    color::Color
end

@default TestSimpleTableWithEnum color=Green

immutable Vec3
    x::Float32
    y::Float32
    z::Float32
    _::UInt32 # padding
    test1::Float64
    test2::Color
    __::UInt8 # padding
    test3::Test
    ___::UInt16 # padding
end

@align Vec3 16

type Stat
    id::String
    val::Int64
    count::UInt16
end

# Julia doesn't support forward referencing of types
# @union Any_ Union{Monster, TestSimpleTableWithEnum}

type Monster
    pos::Vec3
    mana::Int16
    hp::Int16
    name::String
    friendly::Bool # deprecated
    inventory::Vector{UInt8}
    color::Color
    # test_type::Any_
    # test::Vector{UInt8}
    test4::Vector{Test}
    testarrayofstring::Vector{String}
    testarrayoftables::Vector{Monster}
    # don't support nested circulr reference objects yet
    # enemy::Monster
    testnestedflatbuffer::Vector{UInt8}
    testempty::Stat
    testbool::Bool
    testhashs32_fnv1::Int32
    testhashu32_fnv1::UInt32
    testhashs64_fnv1::Int64
    testhashu64_fnv1::UInt64
    testhashs32_fnv1a::Int32
    testhashu32_fnv1a::UInt32
    testhashs64_fnv1a::Int64
    testhashu64_fnv1a::UInt64
    testarrayofbools::Vector{Bool}
    testf::Float32
    testf2::Float32
    testf3::Float32
end

@default Monster hp=100 mana=150 color=Blue friendly=false testf=Float32(3.14159) testf2=Float32(3)

end # module
