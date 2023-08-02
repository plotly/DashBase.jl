using DashBase
using Test
using Plots
plotlyjs()

@testset "PlotlyJS" begin
    pl = @test_nowarn DashBase.to_dash(plot(1:5))
    @test pl isa PlotlyJS.SyncPlot
    pl = @test_nowarn DashBase.to_dash(pl)
    @test haskey(pl, :layout)
    @test haskey(pl, :data)
    @test haskey(pl, :frames)
    @test !haskey(pl, :config)
end

plotly()
@testset "PlotlyBase" begin
    pl = @test_nowarn DashBase.to_dash(plot(1:5))
    @test pl isa PlotlyBase.Plot
    pl = @test_nowarn DashBase.to_dash(pl)
    @test haskey(pl, :layout)
    @test haskey(pl, :data)
    @test haskey(pl, :frames)
    @test !haskey(pl, :config)
end
