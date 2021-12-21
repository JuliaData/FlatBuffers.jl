module Reflection

using FlatBuffers: get, pos, @scopedenum, offset, Table, indirect, init, Array, bytes


@scopedenum BaseType::Int8 None=0 UType=1 Bool=2 Byte=3 UByte=4 Short=5 UShort=6 Int=7 UInt=8 Long=9 ULong=10 Float=11 Double=12 String=13 Vector=14 Obj=15 Union=16 Array=17 MaxBaseType=18 

@scopedenum AdvancedFeatures::UInt64 AdvancedArrayFeatures=1 AdvancedUnionFeatures=2 OptionalScalars=4 DefaultVectorsAndStrings=8 



struct Type_  <: Table
	bytes::Vector{UInt8}
	pos::Base.Int
end

Base.propertynames(::Type_) = (
	:base_type,
	:element,
	:index,
	:fixed_length,
)

function Base.getproperty(x::Type_, field::Symbol)
	if field === :base_type
		o = offset(x, 4)
		o != 0 && return get(x, o + pos(x), BaseType)
		return BaseType(0)
	elseif field === :element
		o = offset(x, 6)
		o != 0 && return get(x, o + pos(x), BaseType)
		return BaseType(0)
	elseif field === :index
		o = offset(x, 8)
		o != 0 && return get(x, o + pos(x), Int32)
		return Int32(-1)
	elseif field === :fixed_length
		o = offset(x, 10)
		o != 0 && return get(x, o + pos(x), UInt16)
		return UInt16(0)
	end
	return nothing
end



struct KeyValue_ <: Table
	bytes::Vector{UInt8}
	pos::Base.Int
end

Base.propertynames(::KeyValue_) = (
	:key,
	:value,
)

function Base.getproperty(x::KeyValue_, field::Symbol)
	if field === :key
		o = offset(x, 4)
		o != 0 && return String(x, o + pos(x))
		return string(0)
	elseif field === :value
		o = offset(x, 6)
		o != 0 && return String(x, o + pos(x))
		return string(0)
	end
	return nothing
end



struct EnumVal_ <: Table
	bytes::Vector{UInt8}
	pos::Base.Int
end

Base.propertynames(::EnumVal_) = (
	:name,
	:value,
	:union_type,
	:documentation,
)

function Base.getproperty(x::EnumVal_, field::Symbol)
	if field === :name
		o = offset(x, 4)
		o != 0 && return String(x, o + pos(x))
		return string(0)
	elseif field === :value
		o = offset(x, 6)
		o != 0 && return get(x, o + pos(x), Int64)
		return Int64(0)
	elseif field === :union_type
		o = offset(x, 10)
		if o != 0
			y = indirect(x, o + pos(x))
			return init(Type_, bytes(x), y)
		end
	elseif field === :documentation
		o = offset(x, 12)
		o != 0 && return Array{[]byte}(x, o)
	end
	return nothing
end



struct Enum_ <: Table
	bytes::Vector{UInt8}
	pos::Base.Int
end

Base.propertynames(::Enum_) = (
	:name,
	:values,
	:is_union,
	:underlying_type,
	:attributes,
	:documentation,
	:declaration_file,
)

function Base.getproperty(x::Enum_, field::Symbol)
	if field === :name
		o = offset(x, 4)
		o != 0 && return String(x, o + pos(x))
		return string(0)
	elseif field === :values
		o = offset(x, 6)
		o != 0 && return Array{EnumVal_}(x, o)
	elseif field === :is_union
		o = offset(x, 8)
		o != 0 && return get(x, o + pos(x), Bool)
		return Bool(false)
	elseif field === :underlying_type
		o = offset(x, 10)
		if o != 0
			y = indirect(x, o + pos(x))
			return init(Type_, bytes(x), y)
		end
	elseif field === :attributes
		o = offset(x, 12)
		o != 0 && return Array{KeyValue_}(x, o)
	elseif field === :documentation
		o = offset(x, 14)
		o != 0 && return Array{[]byte}(x, o)
	elseif field === :declaration_file
		o = offset(x, 16)
		o != 0 && return String(x, o + pos(x))
		return string(0)
	end
	return nothing
end



struct Field_ <: Table
	bytes::Vector{UInt8}
	pos::Base.Int
end

Base.propertynames(::Field_) = (
	:name,
	:type,
	:id,
	:offset,
	:default_integer,
	:default_real,
	:deprecated,
	:required,
	:key,
	:attributes,
	:documentation,
	:optional,
)

function Base.getproperty(x::Field_, field::Symbol)
	if field === :name
		o = offset(x, 4)
		o != 0 && return String(x, o + pos(x))
		return string(0)
	elseif field === :type
		o = offset(x, 6)
		if o != 0
			y = indirect(x, o + pos(x))
			return init(Type_, bytes(x), y)
		end
	elseif field === :id
		o = offset(x, 8)
		o != 0 && return get(x, o + pos(x), UInt16)
		return UInt16(0)
	elseif field === :offset
		o = offset(x, 10)
		o != 0 && return get(x, o + pos(x), UInt16)
		return UInt16(0)
	elseif field === :default_integer
		o = offset(x, 12)
		o != 0 && return get(x, o + pos(x), Int64)
		return Int64(0)
	elseif field === :default_real
		o = offset(x, 14)
		o != 0 && return get(x, o + pos(x), Float64)
		return Float64(0.0)
	elseif field === :deprecated
		o = offset(x, 16)
		o != 0 && return get(x, o + pos(x), Bool)
		return Bool(false)
	elseif field === :required
		o = offset(x, 18)
		o != 0 && return get(x, o + pos(x), Bool)
		return Bool(false)
	elseif field === :key
		o = offset(x, 20)
		o != 0 && return get(x, o + pos(x), Bool)
		return Bool(false)
	elseif field === :attributes
		o = offset(x, 22)
		o != 0 && return Array{KeyValue_}(x, o)
	elseif field === :documentation
		o = offset(x, 24)
		o != 0 && return Array{[]byte}(x, o)
	elseif field === :optional
		o = offset(x, 26)
		o != 0 && return get(x, o + pos(x), Bool)
		return Bool(false)
	end
	return nothing
end



struct Object_ <: Table
	bytes::Vector{UInt8}
	pos::Base.Int
end

Base.propertynames(::Object_) = (
	:name,
	:fields,
	:is_struct,
	:minalign,
	:bytesize,
	:attributes,
	:documentation,
	:declaration_file,
)

function Base.getproperty(x::Object_, field::Symbol)
	if field === :name
		o = offset(x, 4)
		o != 0 && return String(x, o + pos(x))
		return string(0)
	elseif field === :fields
		o = offset(x, 6)
		o != 0 && return Array{Field_}(x, o)
	elseif field === :is_struct
		o = offset(x, 8)
		o != 0 && return get(x, o + pos(x), Bool)
		return Bool(false)
	elseif field === :minalign
		o = offset(x, 10)
		o != 0 && return get(x, o + pos(x), Int32)
		return Int32(0)
	elseif field === :bytesize
		o = offset(x, 12)
		o != 0 && return get(x, o + pos(x), Int32)
		return Int32(0)
	elseif field === :attributes
		o = offset(x, 14)
		o != 0 && return Array{KeyValue_}(x, o)
	elseif field === :documentation
		o = offset(x, 16)
		o != 0 && return Array{[]byte}(x, o)
	elseif field === :declaration_file
		o = offset(x, 18)
		o != 0 && return String(x, o + pos(x))
		return string(0)
	end
	return nothing
end



struct RPCCall_ <: Table
	bytes::Vector{UInt8}
	pos::Base.Int
end

Base.propertynames(::RPCCall_) = (
	:name,
	:request,
	:response,
	:attributes,
	:documentation,
)

function Base.getproperty(x::RPCCall_, field::Symbol)
	if field === :name
		o = offset(x, 4)
		o != 0 && return String(x, o + pos(x))
		return string(0)
	elseif field === :request
		o = offset(x, 6)
		if o != 0
			y = indirect(x, o + pos(x))
			return init(Object_, bytes(x), y)
		end
	elseif field === :response
		o = offset(x, 8)
		if o != 0
			y = indirect(x, o + pos(x))
			return init(Object_, bytes(x), y)
		end
	elseif field === :attributes
		o = offset(x, 10)
		o != 0 && return Array{KeyValue_}(x, o)
	elseif field === :documentation
		o = offset(x, 12)
		o != 0 && return Array{[]byte}(x, o)
	end
	return nothing
end



struct Service_ <: Table
	bytes::Vector{UInt8}
	pos::Base.Int
end

Base.propertynames(::Service_) = (
	:name,
	:calls,
	:attributes,
	:documentation,
	:declaration_file,
)

function Base.getproperty(x::Service_, field::Symbol)
	if field === :name
		o = offset(x, 4)
		o != 0 && return String(x, o + pos(x))
		return string(0)
	elseif field === :calls
		o = offset(x, 6)
		o != 0 && return Array{RPCCall_}(x, o)
	elseif field === :attributes
		o = offset(x, 8)
		o != 0 && return Array{KeyValue_}(x, o)
	elseif field === :documentation
		o = offset(x, 10)
		o != 0 && return Array{[]byte}(x, o)
	elseif field === :declaration_file
		o = offset(x, 12)
		o != 0 && return String(x, o + pos(x))
		return string(0)
	end
	return nothing
end



struct SchemaFile_ <: Table
	bytes::Vector{UInt8}
	pos::Base.Int
end

Base.propertynames(::SchemaFile_) = (
	:filename,
	:included_filenames,
)

function Base.getproperty(x::SchemaFile_, field::Symbol)
	if field === :filename
		o = offset(x, 4)
		o != 0 && return String(x, o + pos(x))
		return string(0)
	elseif field === :included_filenames
		o = offset(x, 6)
		o != 0 && return Array{[]byte}(x, o)
	end
	return nothing
end



struct Schema_ <: Table
	bytes::Vector{UInt8}
	pos::Base.Int
end

Base.propertynames(::Schema_) = (
	:objects,
	:enums,
	:file_ident,
	:file_ext,
	:root_table,
	:services,
	:advanced_features,
	:fbs_files,
)

function Base.getproperty(x::Schema_, field::Symbol)
	if field === :objects
		o = offset(x, 4)
		o != 0 && return Array{Object_}(x, o)
	elseif field === :enums
		o = offset(x, 6)
		o != 0 && return Array{Enum_}(x, o)
	elseif field === :file_ident
		o = offset(x, 8)
		o != 0 && return String(x, o + pos(x))
		return string(0)
	elseif field === :file_ext
		o = offset(x, 10)
		o != 0 && return String(x, o + pos(x))
		return string(0)
	elseif field === :root_table
		o = offset(x, 12)
		if o != 0
			y = indirect(x, o + pos(x))
			return init(Object_, bytes(x), y)
		end
	elseif field === :services
		o = offset(x, 14)
		o != 0 && return Array{Service_}(x, o)
	elseif field === :advanced_features
		o = offset(x, 16)
		o != 0 && return get(x, o + pos(x), AdvancedFeatures)
		return AdvancedFeatures(1)
	elseif field === :fbs_files
		o = offset(x, 18)
		o != 0 && return Array{SchemaFile_}(x, o)
	end
	return nothing
end

end #module
