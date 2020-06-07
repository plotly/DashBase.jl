module DashBase
export Component
import JSON2
export Component

to_dash(t::Any) = t
from_dash(::Type{Any}, t::Any) = t

struct Component 
    type ::String
    namespace ::String
    props ::Dict{Symbol, Any}
    available_props ::Set{Symbol}
    wildcard_props ::Set{Symbol}
end

JSON2.@format Component begin
    available_props => (exclude = true,)
    wildcard_props => (exclude = true,)
end

struct ComponentMaker
    name ::String
    type ::String
    namespace ::String,
    available_props ::Set{Symbol}
    wildcard_props ::Set{Symbol}
    wildcard_regex ::Union{Nothing, Regex}
    function ComponentMaker(name; type, namespace, available_props, wildcard_props)
        wildcard_regex::Union{Nothing, Regex} = nothing   
        if !isempty(wildcard_props)
            wildcard_regex = Regex(join(string.(wildcard_props), "|"))
        end
        return new(name, type, namespace, available_props, wildcard_props, wildcard_regex)
    end
end


function make_component(maker::ComponentMaker; kwargs...)
    props = Dict{Symbol, Any}()
    for (prop, value) in pairs(kwargs)
        if in(prop, maker.available_props) || check_whild(maker, prop)
            push!(props, prop => to_dash(value))
        else
            throw(ArgumentError("Invalid property $(string(prop)) for component $(maker.name)"))
        end
    end        
end

function check_whild(maker::ComponentMaker, name:Symbol)
    isnothing(maker.wildcard_regex) && return true
    return startswith(string(name), maker.wildcard_regex)
end
end # module
