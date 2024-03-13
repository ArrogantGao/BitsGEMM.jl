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

@inbounds function matmul_core!(c::AbstractArray{Bits{T}, 1}, a::AbstractArray{Bits{T}, 1}, b::AbstractArray{Bits{T}, 1}) where{T <: Unsigned}
    n = length(a)
    for i in 1:n
        outer_prod!(c, a[i], b[i])
    end
    return c
end

# here we simply assume that C is column-major, A is column-major, and B is row-major
@inbounds function Bits_matmul!(C::AbstractMatrix{Bits{T}}, A::AbstractMatrix{Bits{T}}, B::AbstractMatrix{Bits{T}}, α::Bool, β::Bool, TM, TN, TK) where{T <: Unsigned}
    M, N = size(A, 1), size(B, 2)
    K = size(A, 2)
    s = sizeof(T) * 8
    @assert size(B, 1) == K
    @assert size(C, 1) == M
    @assert size(C, 2) == N * s
    
    if !α
        fill!(C, zero(Bits{T}))
    end

    if β
        for j in 1:TN:N
            for k in 1:TK:K
                for i in 1:TM:M
                    for kk in k:min(k + TK - 1, K)
                        for jj in j:min(j + TN - 1, N)
                            b = B[kk, jj]
                            for l in 1:s
                                mask = b[s - l + 1]
                                for ii in i:min(i + TM - 1, M)
                                    a = A[ii, kk]
                                    c = C[ii, (jj-1)*s+l]
                                    C[ii, (jj-1)*s+l] = masked_add(c, a, mask)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return C
end