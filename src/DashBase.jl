module DashBase
import JSON2
using YAML
using Pkg.Artifacts
include("components.jl")
include("registry.jl")
include("generate_components.jl")
include("register_resources.jl")
include("wrapper.jl")
export Component, push_prop!, get_name, get_type, get_namespace,
ResourcePkg, Resource, ResourcesRegistry, isdynamic, register_package!, main_registry,
get_dash_dependencies, get_dash_renderer_pkg, get_componens_pkgs,
has_relative_path, has_dev_path, has_external_url, get_type,
get_external_url, get_dev_path, get_relative_path

end # module
