module BitsGEMM

using LinearAlgebra, TropicalNumbers
export Bits, BitsU8, BitsU16, BitsU32, BitsU64, Bits2Bool, Bits2Tropical
export masked_add, outer_prod!

include("types.jl")
include("gemm.jl")

end
