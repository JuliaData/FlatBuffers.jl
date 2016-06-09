using FlatBuffers
using Base.Test

# Compat
if !isdefined(Core, :String)
    typealias String UTF8String
end

include(joinpath(Pkg.dir("FlatBuffers"), "test/internals.jl"))
CheckByteLayout()
CheckManualBuild()
CheckVtableDeduplication()
CheckNotInObjectError()
CheckStringIsNestedError()
CheckByteStringIsNestedError()
CheckStructIsNotInlineError()
CheckFinishedBytesError()
CheckCreateByteVector()
checkFuzz(100, 100, true)

include(joinpath(Pkg.dir("FlatBuffers"), "test/monster.jl"))

vec3 = Example.Vec3(1.0, 2.0, 3.0, 0, 3.0, Example.Color(3), 0, Example.Test(5, 6, 0), 0)
test4 = Example.Test[Example.Test(10, 20, 0), Example.Test(30, 40, 0)]
testArrayOfString = ["test1","test2"]

mon = Example.Monster(vec3, 150, 80, "MyMonster", false, collect(0x00:0x04),
        Example.Blue, test4, testArrayOfString, Example.Monster[],
        UInt8[], Example.Stat("",0,0), false, 0, 0, 0, 0, 0, 0, 0, 0,
        Bool[], 0, 0, 0)
b = FlatBuffers.Builder(Example.Monster)
FlatBuffers.build!(b, mon)
t = FlatBuffers.Table(b)
monst = FlatBuffers.read(t)

@test mon.pos == monst.pos

# create test types
# types (Scalar, Enum, immutable, T, String, Vector{UInt8})
type TestInt8T
    x::Int8
end

inst1 = TestInt8T(1)

b = FlatBuffers.Builder(TestInt8T)
FlatBuffers.build!(b, inst1)
t = FlatBuffers.Table(b)
inst1_2 = FlatBuffers.read(t)

@test inst1.x === inst1_2.x

immutable TestInt8I
    x::Int8
end

inst2 = TestInt8I(2)

type TestInt8A
    x::Vector{Int8}
end

inst3 = TestInt8A([1,2,3])

b = FlatBuffers.Builder(TestInt8A)
FlatBuffers.build!(b, inst3)
t = FlatBuffers.Table(b)
inst3_2 = FlatBuffers.read(t)

@test inst3.x == inst3_2.x

type TestMixT
    x::Int8
    y::String
    z::Vector{Int8}
end

inst4 = TestMixT(10,"hey there sailor",[1,2,3])

b = FlatBuffers.Builder(TestMixT)
FlatBuffers.build!(b, inst4)
t = FlatBuffers.Table(b)
inst4_2 = FlatBuffers.read(t)

@test inst4.x == inst4_2.x && inst4.y == inst4_2.y && inst4.z == inst4_2.z

# simple sub-table/type (Stat)
type TestSubT
    x::TestInt8T
    y::TestInt8I
    z::TestInt8A
end

inst5 = TestSubT(inst1, inst2, inst3)

b = FlatBuffers.Builder(TestSubT)
FlatBuffers.build!(b, inst5)
t = FlatBuffers.Table(b)
inst5_2 = FlatBuffers.read(t)

@test inst5.x.x == inst5_2.x.x && inst5.y.x == inst5_2.y.x && inst5.z.x == inst5_2.z.x

# vtable duplicates
type TestDupT
    x::TestInt8T
    y::TestInt8I
    z::TestInt8T
end

inst6 = TestDupT(inst1, inst2, TestInt8T(2))

b = FlatBuffers.Builder(TestDupT)
FlatBuffers.build!(b, inst6)
t = FlatBuffers.Table(b)
inst6_2 = FlatBuffers.read(t)

@test inst6.x.x == inst6_2.x.x && inst6.y.x == inst6_2.y.x && inst6.z.x == inst6_2.z.x

type TestDup2T
    x::Vector{TestInt8T}
end

inst7 = TestDup2T([inst1, TestInt8T(2), TestInt8T(3), TestInt8T(4)])

b = FlatBuffers.Builder(TestDup2T)
FlatBuffers.build!(b, inst7)
t = FlatBuffers.Table(b)
inst7_2 = FlatBuffers.read(t)

@test all(map(x->x.x, inst7.x) .== map(x->x.x, inst7_2.x))

# self-referential type test (type has subtype of itself)
# type TestCircT
#     x::Int8
#     y::TestCircT
# end
#
# immutable TestCircI
#     x::Int8
#     y::TestCircI
# end

# simple Union (Any_)

# fbs
# table TestUnionT {
#     x::TestUnionI
# }

include(joinpath(Pkg.dir("FlatBuffers"), "src/header.jl"))
@union TestUnionU Union{Void,TestInt8T,TestInt8A}

type TestUnionT
    x_type::Int8
    x::TestUnionU
end

TestUnionT(x::TestUnionU) = TestUnionT(FlatBuffers.typeorder(TestUnionU, typeof(x)), x)

inst8 = TestUnionT(inst1)

b = FlatBuffers.Builder(TestUnionT)
FlatBuffers.build!(b, inst8)
t = FlatBuffers.Table(b)
inst8_2 = FlatBuffers.read(t)

@test inst8.x_type == inst8_2.x_type && inst8.x.x == inst8_2.x.x

inst9 = TestUnionT(inst3)

b = FlatBuffers.Builder(TestUnionT)
FlatBuffers.build!(b, inst9)
t = FlatBuffers.Table(b)
inst9_2 = FlatBuffers.read(t)

@test inst9.x_type == inst9_2.x_type && inst9.x.x == inst9_2.x.x
