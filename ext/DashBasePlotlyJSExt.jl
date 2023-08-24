module DashBasePlotlyJSExt

using DashBase

isdefined(Base, :get_extension) ? (using PlotlyJS) : (using ..PlotlyJS)

function DashBase.to_dash(p::PlotlyJS.SyncPlot)
    DashBase.to_dash(p.plot)
end

end
