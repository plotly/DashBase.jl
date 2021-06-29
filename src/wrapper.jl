macro generate_wrapper()
    return esc(
        quote
            function artifact_dir()
                # We explicitly use `macrocall` here so that we can manually pass the `__source__`
                # argument, to avoid `@artifact_str` trying to lookup `Artifacts.toml` here.
                return $(Expr(:macrocall, Symbol("@artifact_str"), __source__, "resources"))
            end
            function load_meta()
                return DashBase.YAML.load_file(joinpath(artifact_dir(), "meta.yml"))
            end
            macro generate_components()
                meta = load_meta()
                return esc(
                    DashBase.generate_components_package(meta)
                )
            end
            function resources_meta()
                dash_meta = load_meta()
                return filter(dash_meta) do v
                    v.first != "components"
                end
            end
            deps_path() = joinpath(artifact_dir(), "deps")
            const _resources_meta = resources_meta()
            function __init__()
                DashBase.setup_module_resources(_resources_meta, deps_path())
            end
        end
    )
end