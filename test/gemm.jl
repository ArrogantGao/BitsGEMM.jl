@testset "outer product between Bits" begin
    for T in [UInt8, UInt16, UInt32, UInt64]
        a = Bits(rand(T))
        b = Bits(rand(T))
        c = [Bits(rand(T)) for _ in 1:length(a)]

        Ba = Bits2Tropical(a)
        Bb = Bits2Tropical(b)
        Bc = Bits2Tropical(c')

        outer_prod!(c, a, b)
        @test Bits2Tropical(c') == Bc + Ba * Transpose(Bb)
    end
end

@testset "matmul between Bits" begin
    for T in [UInt8, UInt16, UInt32, UInt64]
        A = Bits.(rand(T, 8, 9))
        B = Bits.(rand(T, 7, 9))
        C = Bits.(rand(T, 8, 7 * sizeof(T) * 8))

        Ba = Bits2Tropical(A)
        Bb = Bits2Tropical(B)
        Bc = Bits2Tropical(C)

        C = Bits_matmul!(C, A, Transpose(B), true, true, 16, 16, 16)
        @test Bits2Tropical(C) == Bc + Ba * Transpose(Bb)
    end
end