module DashBase
import JSON3
include("components.jl")
include("registry.jl")
export Component, push_prop!, get_name, get_type, get_namespace,
ResourcePkg, Resource, ResourcesRegistry, isdynamic, register_package!, main_registry,
get_dash_dependencies, get_dash_renderer_pkg, get_componens_pkgs,
has_relative_path, has_dev_path, has_external_url, get_type,
get_external_url, get_dev_path, get_relative_path

@static if !isdefined(Base, :get_extension)
using Requires
end

function __init__()
    @static if !isdefined(Base, :get_extension)
        @require PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5" include("../ext/DashBasePlotlyBaseExt.jl")
        @require PlotlyJS = "f0f68f2c-4968-5e81-91da-67840de0976a" include("../ext/DashBasePlotlyJSExt.jl")
        @require Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80" include("../ext/DashBasePlotsExt.jl")
    end
end

end # module
