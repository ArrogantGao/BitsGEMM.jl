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