

dash_dependency_resource(meta) = Resource(
        relative_package_path = meta["relative_package_path"],
        external_url = meta["external_url"]
    )

nothing_if_empty(v) = isempty(v) ? nothing : v

dash_module_resource(meta) = Resource(
        relative_package_path = nothing_if_empty(get(meta, "relative_package_path", "")),
        external_url = nothing_if_empty(get(meta, "external_url", "")),
        dev_package_path = nothing_if_empty(get(meta, "dev_package_path", "")),
        dynamic = get(meta, "dynamic", nothing),
        type = Symbol(meta["type"]),
        async = haskey(meta, "async") ? string(meta["async"]) : nothing
    )

dash_module_resource_pkg(meta; resource_path, version) = ResourcePkg(
    meta["namespace"],
    resource_path, version = version,
    dash_module_resource.(meta["resources"])
)


function setup_module_resources(meta, path)
    version = meta["version"]
    for dep in meta["deps"]
        DashBase.register_package(
            dash_module_resource_pkg(
                dep,
                resource_path = path,
                version = version
            )
        )
    end
end