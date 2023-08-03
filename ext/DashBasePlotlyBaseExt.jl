module DashBasePlotlyBaseExt

import DashBase
import PlotlyBase
import PlotlyBase.JSON

function DashBase.to_dash(p::PlotlyBase.Plot)
    data = JSON.lower(p)
    pop!(data, :config, nothing)
    return data
end

end
