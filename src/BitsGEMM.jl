module BitsGEMM

using LinearAlgebra, TropicalNumbers, LoopVectorization
export Bits, BitsU8, BitsU16, BitsU32, BitsU64, Bits2Bool, Bits2Tropical
export masked_add, outer_prod!, matmul_core!, Bits_matmul!

include("types.jl")
include("gemm.jl")

end
