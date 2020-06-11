struct Resource       
    relative_package_path::Union{Nothing, Vector{String}}
    dev_package_path::Union{Nothing, Vector{String}}
    external_url::Union{Nothing, Vector{String}}
    type::Symbol 
    async::Symbol # :none, :eager, :lazy May be we should use enum
    function Resource(;relative_package_path, dev_package_path = nothing, external_url = nothing, type = :js, dynamic = nothing, async=nothing) 
        (!isnothing(dynamic) && !isnothing(async)) && throw(ArgumentError("Can't have both 'dynamic' and 'async'"))
        !in(type, [:js, :css]) &&  throw(ArgumentError("type must be `:js` or `:css`"))
        async_symbol = :none
        if !isnothing(dynamic)
            dynamic == true && (async_symbol = :lazy)
        elseif !isnothing(async) && async != :false
            async_symbol = async == :lazy ? :lazy : :eager
        end
        return new(_path_to_vector(relative_package_path), _path_to_vector(dev_package_path), _path_to_vector(external_url), type, async_symbol)
    end
end

_path_to_vector(s::Nothing) = nothing
_path_to_vector(s::String) = [s]
_path_to_vector(s::Vector{String}) = s

has_relative_path(r::Resource) = !isnothing(r.relative_package_path)
has_dev_path(r::Resource) = !isnothing(r.dev_package_path)
has_external_url(r::Resource) = !isnothing(r.external_url)

get_type(r::Resource) = r.type
get_external_url(r::Resource) = r.external_url
get_dev_path(r::Resource) = r.dev_package_path
get_relative_path(r::Resource) = r.relative_package_path

isdynamic(resource::Resource, eager_loading::Bool) = resource.async == :lazy || (resource.async == :eager && !eager_loading)

struct ResourcePkg
    namespace ::String
    path ::String
    resources ::Vector{Resource}    
    version ::String
    ResourcePkg(namespace, path, resources = Resource[]; version = "")  = new(namespace, path, resources, version)
end


mutable struct ResourcesRegistry    
    components ::Dict{String, ResourcePkg}
    dash_dependency ::Union{Nothing, NamedTuple{(:dev, :prod), Tuple{ResourcePkg,ResourcePkg}}}
    dash_renderer ::Union{Nothing, ResourcePkg}
    ResourcesRegistry() = new(Dict{String, ResourcePkg}(), nothing, nothing)
    ResourcesRegistry(;dash_dependency, dash_renderer) = new(Dict{String, ResourcePkg}(), dash_dependency, dash_renderer)
end

get_dash_dependencies(registry::ResourcesRegistry, prop_check::Bool) = prop_check ?
                                                                    registry.dash_dependency[:dev] :
                                                                    registry.dash_dependency[:prod]

get_componens_pkgs(registry::ResourcesRegistry) = values(registry.components)
get_dash_renderer_pkg(registry::ResourcesRegistry) = registry.dash_renderer 

function register_package!(registry::ResourcesRegistry, pkg::ResourcePkg)
    registry.components[pkg.namespace] = pkg
end

const resources_registry = ResourcesRegistry()

register_package(pkg::ResourcePkg) = register_package!(resources_registry, pkg)

main_registry() = resources_registry
