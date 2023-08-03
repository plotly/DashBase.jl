module DashBasePlotsExt

import Plots
import DashBase


function DashBase.to_dash(p::Plots.Plot{Plots.PlotlyBackend})
    return if haskey(Base.loaded_modules, Base.PkgId(Base.UUID("a03496cd-edff-5a9b-9e67-9cda94a718b5"), "PlotlyBase")) &&
        haskey(Base.loaded_modules, Base.PkgId(Base.UUID("f2990250-8cf9-495f-b13a-cce12b45703c"), "PlotlyKaleido"))
        # Note: technically it would be sufficient if PlotlyBase is loaded, but thats how it is currently handled by Plots.jl
        Plots.plotlybase_syncplot(p)
    else
        (data = Plots.plotly_series(p), layout = Plots.plotly_layout(p))
    end
end
DashBase.to_dash(p::Plots.Plot{Plots.PlotlyJSBackend}) = Plots.plotlyjs_syncplot(p)

end
