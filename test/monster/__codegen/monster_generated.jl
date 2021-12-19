# Code generated by the FlatBuffers compiler. DO NOT EDIT.

module Foo

using FlatBuffers

FlatBuffers.@scopedenum Color::Int8 Red=0 Green=1 Blue=2 

struct Vec3 <: FlatBuffers.Struct
	bytes::Vector{UInt8}
	pos::Base.Int
end

Base.propertynames(::Vec3) = (
	:x,
	:y,
	:z,
)

function Base.getproperty(x::Vec3, field::Symbol)
	if field === :x
		#GetScalarFieldOfStruct
		return FlatBuffers.get(x, FlatBuffers.pos(x) + 0, Float32)
	elseif field === :y
		#GetScalarFieldOfStruct
		return FlatBuffers.get(x, FlatBuffers.pos(x) + 4, Float32)
	elseif field === :z
		#GetScalarFieldOfStruct
		return FlatBuffers.get(x, FlatBuffers.pos(x) + 8, Float32)
	end
	return nothing
end

module Vec3Properties
abstract type AbstractProperty end
struct x <: AbstractProperty end
struct y <: AbstractProperty end
struct z <: AbstractProperty end
end

function Base.getindex(x::Vec3, ::Type{Vec3Properties.x})
		#GetScalarFieldOfStruct
		return FlatBuffers.get(x, FlatBuffers.pos(x) + 0, Float32)
end

function Base.getindex(x::Vec3, ::Type{Vec3Properties.y})
		#GetScalarFieldOfStruct
		return FlatBuffers.get(x, FlatBuffers.pos(x) + 4, Float32)
end

function Base.getindex(x::Vec3, ::Type{Vec3Properties.z})
		#GetScalarFieldOfStruct
		return FlatBuffers.get(x, FlatBuffers.pos(x) + 8, Float32)
end


function createVec3(b::FlatBuffers.Builder, x::Float32, y::Float32, z::Float32)
	FlatBuffers.prep!(b, 4, 12)
	FlatBuffers.prepend!(b, z)
	FlatBuffers.prepend!(b, y)
	FlatBuffers.prepend!(b, x)
	return FlatBuffers.offset(b)
end
struct Monster <: FlatBuffers.Table
	bytes::Vector{UInt8}
	pos::Base.Int
end

Base.propertynames(::Monster) = (
	:pos,
	:mana,
	:hp,
	:name,
	:inventory,
	:color,
	:weapons,
	:path,
)

function Base.getproperty(x::Monster, field::Symbol)
	if field === :pos
		#GetStructFieldOfTable
		o = FlatBuffers.offset(x, 4)
		if o != 0
			y = FlatBuffers.indirect(x, o + FlatBuffers.pos(x))
			return FlatBuffers.init(Vec3, FlatBuffers.bytes(x), y)
		end
	elseif field === :mana
		#GetScalarFieldOfTable
		o = FlatBuffers.offset(x, 6)
		o != 0 && return FlatBuffers.get(x, o + FlatBuffers.pos(x), Int16)
		return Int16(150)
	elseif field === :hp
		#GetScalarFieldOfTable
		o = FlatBuffers.offset(x, 8)
		o != 0 && return FlatBuffers.get(x, o + FlatBuffers.pos(x), Int16)
		return Int16(100)
	elseif field === :name
		#GetStringField
		o = FlatBuffers.offset(x, 10)
		o != 0 && return String(x, o + FlatBuffers.pos(x))
		return string(0)
	elseif field === :inventory
		#GetMemberOfVectorOfNonStruct
		o = FlatBuffers.offset(x, 14)
		o != 0 && return FlatBuffers.Array{UInt8}(x, o)
	elseif field === :color
		#GetScalarFieldOfTable
		o = FlatBuffers.offset(x, 16)
		o != 0 && return FlatBuffers.get(x, o + FlatBuffers.pos(x), Color)
		return Color(2)
	elseif field === :weapons
		#GetMemberOfVectorOfStruct
		o = FlatBuffers.offset(x, 18)
		o != 0 && return FlatBuffers.Array{Weapon}(x, o)
	elseif field === :path
		#GetMemberOfVectorOfStruct
		o = FlatBuffers.offset(x, 20)
		o != 0 && return FlatBuffers.Array{Vec3}(x, o)
	end
	return nothing
end

module MonsterProperties
abstract type AbstractProperty end
struct pos <: AbstractProperty end
struct mana <: AbstractProperty end
struct hp <: AbstractProperty end
struct name <: AbstractProperty end
struct inventory <: AbstractProperty end
struct color <: AbstractProperty end
struct weapons <: AbstractProperty end
struct path <: AbstractProperty end
end

function Base.getindex(x::Monster, ::Type{MonsterProperties.pos})
		#GetStructFieldOfTable
		o = FlatBuffers.offset(x, 4)
		if o != 0
			y = FlatBuffers.indirect(x, o + FlatBuffers.pos(x))
			return FlatBuffers.init(Vec3, FlatBuffers.bytes(x), y)
		end
		return nothing
end

function Base.getindex(x::Monster, ::Type{MonsterProperties.mana})
		#GetScalarFieldOfTable
		o = FlatBuffers.offset(x, 6)
		o != 0 && return FlatBuffers.get(x, o + FlatBuffers.pos(x), Int16)
		return Int16(150)
end

function Base.getindex(x::Monster, ::Type{MonsterProperties.hp})
		#GetScalarFieldOfTable
		o = FlatBuffers.offset(x, 8)
		o != 0 && return FlatBuffers.get(x, o + FlatBuffers.pos(x), Int16)
		return Int16(100)
end

function Base.getindex(x::Monster, ::Type{MonsterProperties.name})
		#GetStringField
		o = FlatBuffers.offset(x, 10)
		o != 0 && return String(x, o + FlatBuffers.pos(x))
		return string(0)
		return nothing
end

function Base.getindex(x::Monster, ::Type{MonsterProperties.inventory})
		#GetMemberOfVectorOfNonStruct
		o = FlatBuffers.offset(x, 14)
		o != 0 && return FlatBuffers.Array{UInt8}(x, o)
		return nothing
end

function Base.getindex(x::Monster, ::Type{MonsterProperties.color})
		#GetScalarFieldOfTable
		o = FlatBuffers.offset(x, 16)
		o != 0 && return FlatBuffers.get(x, o + FlatBuffers.pos(x), Color)
		return Color(2)
end

function Base.getindex(x::Monster, ::Type{MonsterProperties.weapons})
		#GetMemberOfVectorOfStruct
		o = FlatBuffers.offset(x, 18)
		o != 0 && return FlatBuffers.Array{Weapon}(x, o)
		return nothing
end

function Base.getindex(x::Monster, ::Type{MonsterProperties.path})
		#GetMemberOfVectorOfStruct
		o = FlatBuffers.offset(x, 20)
		o != 0 && return FlatBuffers.Array{Vec3}(x, o)
		return nothing
end


MonsterStart(b::FlatBuffers.Builder) = FlatBuffers.startobject!(b, 9)
MonsterAddPos(b::FlatBuffers.Builder, pos::FlatBuffers.UOffsetT) = FlatBuffers.prependoffsetslot!(b, 0, pos, 0)
MonsterAddMana(b::FlatBuffers.Builder, mana::Int16) = FlatBuffers.prependslot!(b, 1, mana, 150)
MonsterAddHp(b::FlatBuffers.Builder, hp::Int16) = FlatBuffers.prependslot!(b, 2, hp, 100)
MonsterAddName(b::FlatBuffers.Builder, name::FlatBuffers.UOffsetT) = FlatBuffers.prependoffsetslot!(b, 3, name, 0)
MonsterAddInventory(b::FlatBuffers.Builder, inventory::FlatBuffers.UOffsetT) = FlatBuffers.prependoffsetslot!(b, 5, inventory, 0)
MonsterStartInventoryVector(b::FlatBuffers.Builder, numelems::Integer) = FlatBuffers.startvector!(b, 1, numelems, 1)
MonsterAddColor(b::FlatBuffers.Builder, color::Color) = FlatBuffers.prependslot!(b, 6, color, 2)
MonsterAddWeapons(b::FlatBuffers.Builder, weapons::FlatBuffers.UOffsetT) = FlatBuffers.prependoffsetslot!(b, 7, weapons, 0)
MonsterStartWeaponsVector(b::FlatBuffers.Builder, numelems::Integer) = FlatBuffers.startvector!(b, 4, numelems, 4)
MonsterAddPath(b::FlatBuffers.Builder, path::FlatBuffers.UOffsetT) = FlatBuffers.prependoffsetslot!(b, 8, path, 0)
MonsterStartPathVector(b::FlatBuffers.Builder, numelems::Integer) = FlatBuffers.startvector!(b, 12, numelems, 4)
MonsterEnd(b::FlatBuffers.Builder) = FlatBuffers.endobject!(b)

struct Weapon <: FlatBuffers.Table
	bytes::Vector{UInt8}
	pos::Base.Int
end

Base.propertynames(::Weapon) = (
	:name,
	:damage,
)

function Base.getproperty(x::Weapon, field::Symbol)
	if field === :name
		#GetStringField
		o = FlatBuffers.offset(x, 4)
		o != 0 && return String(x, o + FlatBuffers.pos(x))
		return string(0)
	elseif field === :damage
		#GetScalarFieldOfTable
		o = FlatBuffers.offset(x, 6)
		o != 0 && return FlatBuffers.get(x, o + FlatBuffers.pos(x), Int16)
		return Int16(0)
	end
	return nothing
end

module WeaponProperties
abstract type AbstractProperty end
struct name <: AbstractProperty end
struct damage <: AbstractProperty end
end

function Base.getindex(x::Weapon, ::Type{WeaponProperties.name})
		#GetStringField
		o = FlatBuffers.offset(x, 4)
		o != 0 && return String(x, o + FlatBuffers.pos(x))
		return string(0)
		return nothing
end

function Base.getindex(x::Weapon, ::Type{WeaponProperties.damage})
		#GetScalarFieldOfTable
		o = FlatBuffers.offset(x, 6)
		o != 0 && return FlatBuffers.get(x, o + FlatBuffers.pos(x), Int16)
		return Int16(0)
end


WeaponStart(b::FlatBuffers.Builder) = FlatBuffers.startobject!(b, 2)
WeaponAddName(b::FlatBuffers.Builder, name::FlatBuffers.UOffsetT) = FlatBuffers.prependoffsetslot!(b, 0, name, 0)
WeaponAddDamage(b::FlatBuffers.Builder, damage::Int16) = FlatBuffers.prependslot!(b, 1, damage, 0)
WeaponEnd(b::FlatBuffers.Builder) = FlatBuffers.endobject!(b)



end #module
