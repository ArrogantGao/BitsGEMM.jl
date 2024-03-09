using BitsGEMM
using Test
using TropicalNumbers, TropicalGEMM, LinearAlgebra

@testset "BitsGEMM.jl" begin
    include("gemm.jl")
end
