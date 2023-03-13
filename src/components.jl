to_dash(t::Any) = t

struct Component 
    name ::String
    type ::String
    namespace ::String
    props ::Dict{Symbol, Any}
    available_props ::Set{Symbol}
    wildcard_regex ::Union{Nothing, Regex}
    function Component(name::String, type::String, namespace::String,
                            props::Vector{Symbol}, wildcard_props::Vector{Symbol}; kwargs...)
        
        available_props = Set{Symbol}(props)
        wildcard_regex::Union{Nothing, Regex} = nothing   
        if !isempty(wildcard_props)
            wildcard_regex = Regex(join(string.(wildcard_props), "|"))
        end
        component = new(name, type, namespace, Dict{Symbol, Any}(), available_props, wildcard_regex)
        for (prop, value) in kwargs
            Base.setproperty!(component, prop, value)
        end
        return component
    end
end

get_name(comp::Component) = getfield(comp, :name)
get_type(comp::Component) = getfield(comp, :type)
get_namespace(comp::Component) = getfield(comp, :namespace)
get_available_props(comp::Component) = getfield(comp, :available_props)
get_wildcard_regex(comp::Component) = getfield(comp, :wildcard_regex)
get_props(comp::Component) = getfield(comp, :props)

function Base.getproperty(comp::Component, prop::Symbol) 
    !Base.hasproperty(comp, prop) && error("Component $(get_name(comp)) has no property $(prop)")
    props = get_props(comp)
    return haskey(props, prop) ? props[prop] : nothing
end

function Base.setproperty!(comp::Component, prop::Symbol, value) 
    !Base.hasproperty(comp, prop) && error("Component $(get_name(comp)) has no property $(prop)")
    props = get_props(comp)
    push!(props, prop=>to_dash(value))
end

function check_whild(wildcard_regex::Union{Nothing, Regex}, name::Symbol)
    isnothing(wildcard_regex) && return false
    return startswith(string(name), wildcard_regex)
end

function Base.hasproperty(comp::Component, prop::Symbol)
    return in(prop, get_available_props(comp)) || check_whild(get_wildcard_regex(comp), prop)
end

Base.propertynames(comp::Component) = collect(get_available_props(comp))

push_prop!(component::Component, prop::Symbol, value) = push!(component.props, prop=>to_dash(value))

JSON3.StructTypes.StructType(::Type{DashBase.Component}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.excludes(::Type{DashBase.Component}) = (:name, :available_props, :wildcard_regex)