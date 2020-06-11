module DashBase
import JSON2
include("components.jl")
include("registry.jl")
export Component, push_prop!, get_name, get_type, get_namespace,
ResourcePkg, Resource, ResourcesRegistry, isdynamic, register_package!, main_registry

end # module
