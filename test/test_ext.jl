using Test
using DashBase
import PlotlyBase
import PlotlyJS
import Plots

function run_assertions(pl)
    obj = @test_nowarn DashBase.to_dash(pl)
    @test obj isa Dict{Symbol, Any}
    @test obj[:data][1][:y] == [1, 2, 3, 4, 5]
    @test haskey(obj, :layout)
    @test haskey(obj, :frames)
    @test !haskey(obj, :config)
end

@testset "DashBasePlotlyBaseExt" begin
    pl = PlotlyBase.Plot(1:5)
    run_assertions(pl)
end

@testset "DashBasePlotsJSExt" begin
    pl = PlotlyJS.plot(1:5)
    run_assertions(pl)
end

@testset "DashBasePlotsExt + plotlyjs()" begin
    Plots.plotlyjs()
    pl = Plots.plot(1:5)
    run_assertions(pl)
end

@testset "DashBasePlotsExt + plotly()" begin
    Plots.plotly()
    pl = Plots.plot(1:5)
    run_assertions(pl)
end
