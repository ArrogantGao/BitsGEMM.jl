
abstract type AbstractBits <: Real end 

struct Bits{T <: Unsigned} <: AbstractBits
    x::T
end

BitsU8 = Bits{UInt8}
BitsU16 = Bits{UInt16}
BitsU32 = Bits{UInt32}
BitsU64 = Bits{UInt64}

function Bits(x::T, T1::DataType) where{T <: Unsigned} return Bits{T1}(T1(x)) end

Base.sizeof(::Type{Bits{T}}) where{T} = sizeof(T)

Base.show(io::IO, t::Bits) = Base.print(io, "$(bitstring(t.x))")

Base.:+(x::Bits{T}, y::Bits{T}) where{T} = Bits(x.x .| y.x)
Base.:*(x::Bits{T}, y::Bits{T}) where{T} = Bits(x.x .& y.x)
Base.getindex(x::Bits{T}, i::TI) where{T, TI <: Integer} = Bool((x.x >> (i - 1)) & true)
Base.length(x::Bits) = sizeof(x.x) * 8
Base.one(::Type{Bits{T}}) where{T} = Bits{T}(typemax(T))
Base.zero(::Type{Bits{T}}) where{T} = Bits{T}(zero(T))

function Bits2Bool(x::Bits)
    n = length(x)
    return [x[n - i + 1] for i in 1:n]
end

function Bits2Bool(x::AbstractArray{T}) where{T <: Bits}
    s = size(x)
    l = sizeof(T) * 8
    v = reduce(vcat, Bits2Bool.(x))
    return reshape(v, (s[1] * l, s[2:end]...))
end

function Bits2Tropical(x::Union{AbstractArray{T}, T}) where{T <: Bits}
    return TropicalAndOr.(Bits2Bool(x))
end