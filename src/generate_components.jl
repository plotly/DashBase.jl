function generate_component!(block, module_name, prefix, meta)
    args = isempty(meta["args"]) ? Symbol[] : Symbol.(meta["args"])
    wild_args = isempty(meta["wild_args"]) ? Symbol[] : Symbol.(meta["wild_args"])
    fname = string(prefix, "_", lowercase(meta["name"]))
    fsymbol = Symbol(fname)

    append!(block.args,
            (quote
                export $fsymbol
                function $(fsymbol)(;kwargs...)
                    available_props = $args
                    wild_props = $wild_args
                    return Component($fname, $(meta["name"]), $module_name, available_props, wild_props; kwargs...)
                end
            end).args
    )
    signatures = String[string(repeat(" ", 4), fname, "(;kwargs...)")]
    if in(:children, args)
        append!(block.args,
            (quote
                $(fsymbol)(children::Any; kwargs...) = $(fsymbol)(;kwargs..., children = children)
                $(fsymbol)(children_maker::Function; kwargs...) = $(fsymbol)(children_maker();kwargs...)
            end).args
        )
        push!(signatures,
            string(repeat(" ", 4), fname, "(children::Any, kwargs...)")
        )
        push!(signatures,
            string(repeat(" ", 4), fname, "(children_maker::Function, kwargs...)")
        )
    end
    docstr = string(
        join(signatures, "\n"),
        "\n\n",
        meta["docstr"]
    )
    push!(block.args, :(@doc $docstr $fsymbol))
end

function generate_components_package(meta)
    result = Expr(:block)
    name  = meta["name"]
    prefix  = meta["prefix"]
    for cmeta in meta["components"]
        generate_component!(result, name, prefix, cmeta)
    end
    return result
end