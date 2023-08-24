module DashBasePlotlyBaseExt

using DashBase

isdefined(Base, :get_extension) ? (using PlotlyBase) : (using ..PlotlyBase)

const JSON = PlotlyBase.JSON

function DashBase.to_dash(p::PlotlyBase.Plot)
    data = JSON.lower(p)
    pop!(data, :config, nothing)
    return data
end

end
