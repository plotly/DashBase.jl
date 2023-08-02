module DashBasePlotlyJSExt

import PlotlyJS
import DashBase

function DashBase.to_dash(p::PlotlyJS.SyncPlot)
    DashBase.to_dash(p.plot)
end

end
