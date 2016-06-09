using FlatBuffers

if !isdefined(Core, :String)
    typealias String UTF8String
end

macro union(T, TT)
    TT.args[1] == :Union || throw(ArgumentError("2nd argument must be a `Union{T1,T2...}` type"))
    return quote
        typealias $(esc(T)) $(esc(TT))
        $(esc(:(FlatBuffers.typeorder))){TT}(::Type{$(esc(T))}, ::Type{TT}) = $(Dict{DataType,Int}([eval(typ)=>i-1 for (i,typ) in enumerate(TT.args[2:end])]))[TT]
        $(esc(:(FlatBuffers.typeorder)))(::Type{$(esc(T))}, i::Integer) = $(Dict{Int,DataType}([i-1=>eval(typ) for (i,typ) in enumerate(TT.args[2:end])]))[i]
    end
end

macro default(T, kwargs...)
    ifblock = quote end
    for kw in kwargs
        push!(ifblock.args, :(if sym == $(QuoteNode(kw.args[1]))
                                  return $(kw.args[2])
                              end))
    end
    return quote
        function $(esc(:(FlatBuffers.default)))(::Type{$(esc(T))}, TT, sym)
            $ifblock
            return FlatBuffers.default(TT)
        end
    end
end

macro align(T, sz)
    return quote
        $(esc(:(FlatBuffers.alignment)))(::Type{$(esc(T))}) = $sz
    end
end

#TODO:
 # provide @enumsize macro
 # provide @typeorder macro
 # provide a @padding macro?
 # should @default also define additional constructors?
