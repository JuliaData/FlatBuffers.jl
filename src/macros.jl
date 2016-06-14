export @union, @default, @align, @struct

macro union(T, TT)
    TT.args[1] == :Union || throw(ArgumentError("2nd argument must be a `Union{T1,T2...}` type"))
    return quote
        typealias $(esc(T)) $(esc(TT))
        $(esc(:(FlatBuffers.typeorder))){TT}(::Type{$(esc(T))}, ::Type{TT}) = $(Dict{DataType,Int}([eval(current_module(), typ)=>i-1 for (i,typ) in enumerate(TT.args[2:end])]))[TT]
        $(esc(:(FlatBuffers.typeorder)))(::Type{$(esc(T))}, i::Integer) = $(Dict{Int,DataType}([i-1=>eval(current_module(), typ) for (i,typ) in enumerate(TT.args[2:end])]))[i]
    end
end

macro align(T, sz)
    return quote
        $(esc(:(FlatBuffers.alignment)))(::Type{$(esc(T))}) = $sz
    end
end

macro enumtype(T, typ)
    return quote
        $(esc(:(FlatBuffers.enumtype)))(::Type{$(esc(T))}) = $typ
    end
end

# recursively finds largest field of a struct
fbsizeof{T<:Enum}(::Type{T}) = sizeof(enumtype(T))
fbsizeof{T}(::Type{T}) = sizeof(T)

maxsizeof{T<:Enum}(::Type{T}) = sizeof(enumtype(T))
maxsizeof{T}(::Type{T}) = isbitstype(T) ? sizeof(T) : maximum(map(x->maxsizeof(x), T.types))

nextsizeof{T}(::Type{T}) = isbitstype(T) ? sizeof(T) : nextsizeof(T.types[1])

function fieldlayout(typ, exprs...)
    fields = Expr[]
    values = []
    largest_field = maximum(map(x->maxsizeof(eval(current_module(), x.args[2])), exprs))
    sz = cur_sz = 0
    x = 0
    for (i,expr) in enumerate(exprs)
        T = eval(current_module(), expr.args[2])
        if !isbitstype(T)
            exprs2 = [Expr(:(::), nm, typ) for (nm,typ) in zip(fieldnames(T),T.types)]
            fields2, values2 = fieldlayout(T, exprs2...)
            append!(fields, map(x->Expr(:(::), Symbol(string(expr.args[1],'_',T,'_',x.args[1])), x.args[2]), fields2))
            append!(values, map(x->x == 0 ? 0 : Expr(:call, :getfield, expr.args[1], QuoteNode(x)), values2))
        else
            push!(fields, expr)
            push!(values, expr.args[1])
        end
        sz += cur_sz = fbsizeof(T)
        if sz % largest_field == 0
            sz = cur_sz = 0
            continue
        end
        nextsz = i == length(exprs) ? 0 : nextsizeof(eval(current_module(), exprs[i+1].args[2]))
        if i == length(exprs) || cur_sz < nextsz || (sz + nextsz) > largest_field
            # this is the last field and we're not `sz % largest_field`
            # potential diffs = 7, 6, 5, 4, 3, 2, 1
            sym = expr.args[1]
            diff = cur_sz < nextsz ? nextsz - cur_sz : largest_field - sz
            if diff == 7
                push!(fields, Expr(:(::), Symbol("_pad_$(sym)_$(typ)_$x"), :UInt8)); x += 1
                push!(fields, Expr(:(::), Symbol("_pad_$(sym)_$(typ)_$x"), :UInt16)); x += 1
                push!(fields, Expr(:(::), Symbol("_pad_$(sym)_$(typ)_$x"), :UInt32)); x += 1
                push!(values, 0); push!(values, 0); push!(values, 0)
            elseif diff == 6
                push!(fields, Expr(:(::), Symbol("_pad_$(sym)_$(typ)_$x"), :UInt16)); x += 1
                push!(fields, Expr(:(::), Symbol("_pad_$(sym)_$(typ)_$x"), :UInt32)); x += 1
                push!(values, 0); push!(values, 0)
            elseif diff == 5
                push!(fields, Expr(:(::), Symbol("_pad_$(sym)_$(typ)_$x"), :UInt8)); x += 1
                push!(fields, Expr(:(::), Symbol("_pad_$(sym)_$(typ)_$x"), :UInt32)); x += 1
                push!(values, 0); push!(values, 0)
            elseif diff == 4
                push!(fields, Expr(:(::), Symbol("_pad_$(sym)_$(typ)_$x"), :UInt32)); x += 1
                push!(values, 0)
            elseif diff == 3
                push!(fields, Expr(:(::), Symbol("_pad_$(sym)_$(typ)_$x"), :UInt8)); x += 1
                push!(fields, Expr(:(::), Symbol("_pad_$(sym)_$(typ)_$x"), :UInt16)); x += 1
                push!(values, 0); push!(values, 0)
            elseif diff == 2
                push!(fields, Expr(:(::), Symbol("_pad_$(sym)_$(typ)_$x"), :UInt16)); x += 1
                push!(values, 0)
            elseif diff == 1
                push!(fields, Expr(:(::), Symbol("_pad_$(sym)_$(typ)_$x"), :UInt8)); x += 1
                push!(values, 0)
            end
            sz = (sz + diff) % largest_field == 0 ? 0 : (cur_sz < nextsz ? sz + diff : 0)
            cur_sz = 0
        end
    end
    return fields, values
end

macro struct(expr)
    !expr.args[1] || throw(ArgumentError("@struct is only applicable for immutable types"))
    exprs = filter(x->x.head !== :line, expr.args[3].args)
    fields, values = FlatBuffers.fieldlayout(expr.args[2], exprs...)
    expr.args[3].args = fields
    # generate convenience outer constructors if necessary
     # if there are nested structs or padding:
        # build an outer constructor that takes all direct, original fields
        # recursively flatten/splat all nested structs into one big args tuple
        # adding zeros for padded arguments
        # pass big, flat, args tuple to inner constructor
    T = expr.args[2]
    if any(x->!FlatBuffers.isbitstype(eval(current_module(), x.args[2])), exprs) ||
       length(fields) > length(exprs)
       exprs2 = map(x->FlatBuffers.isbitstype(eval(current_module(), x.args[2])) ? x.args[1] : x, exprs)
       sig = Expr(:call, T, exprs2...)
       body = Expr(:call, T, values...)
       outer = Expr(:function, sig, body)
    else
        outer = :(nothing)
    end
    return quote
        $(esc(expr))
        $(esc(outer))
    end
end

macro default(T, kwargs...)
    if eval(current_module(), T) <: Enum
        return quote
            # default{T<:Enum}(::Type{T}) = enumtype(T)(T(0))
            $(esc(:(FlatBuffers.default)))(::Type{$(esc(T))}) = $(esc(:(FlatBuffers.enumtype)))($(esc(T)))($(esc(kwargs[1])))
        end
    else
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
end

#TODO:
# handle default values
# handle unions
# handle id?
# handle deprecated
# nested_flatbuffer
macro table(expr)

end
