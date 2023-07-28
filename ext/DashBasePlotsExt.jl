module DashBasePlotsExt

import Plots
import DashBase


DashBase.to_dash(p::Plots.Plot{Plots.PlotlyBackend}) = (data = Plots.plotly_series(p), layout = Plots.plotly_layout(p))

end
