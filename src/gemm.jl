"""
    masked_add(x::Bits{T}, y::Bits{T}, mask::Bool) where{T}
    x + mask * y
"""
@inline masked_add(x::Bits{T}, y::Bits{T}, mask::Bool) where{T} = mask ? x + y : x

@inbounds function outer_prod!(c::AbstractArray{Bits{T}, 1}, a::Bits{T}, b::Bits{T}) where{T <: Unsigned}
    n = length(a)
    for i in 1:length(a)
        c[i] = masked_add(c[i], a, b[n - i + 1])
    end
    return c
end