using DashBase
@testset "lazy + dynamic" begin
    test_resource = Resource(
        relative_package_path = "test.js",
        dynamic = true
    )
    @test test_resource.async == :lazy
    @test DashBase.isdynamic(test_resource, true)
    @test DashBase.isdynamic(test_resource, false)

    test_resource = Resource(
        relative_package_path = "test.js",
        dynamic = false
    )
    @test test_resource.async == :none
    @test !DashBase.isdynamic(test_resource, true)
    @test !DashBase.isdynamic(test_resource, false)

    @test_throws ArgumentError test_resource = Resource(
        relative_package_path = "test.js",
        dynamic = false,
        async = :false
    )

    test_resource = Resource(
        relative_package_path = "test.js",
        async = :lazy
    )

    @test test_resource.async == :lazy
    @test DashBase.isdynamic(test_resource, true)
    @test DashBase.isdynamic(test_resource, false)

    test_resource = Resource(
        relative_package_path = "test.js",
        async = :eager
    )

    @test test_resource.async == :eager
    @test !DashBase.isdynamic(test_resource, true)
    @test DashBase.isdynamic(test_resource, false)
end

@testset "register" begin
    DashBase.register_package(
        ResourcePkg(
            "dash_html_components",
            "path",
            version = "1.2.3",
            [
                Resource(
                    relative_package_path = "dash_html_components.min.js",
                    external_url = "https://unpkg.com/dash-html-components@1.0.1/dash_html_components/dash_html_components.min.js",
                    dynamic = nothing,
                    async = nothing,
                    type = :js
                ),
                Resource(
                    relative_package_path = "dash_html_components.min.js.map",
                    external_url = "https://unpkg.com/dash-html-components@1.0.1/dash_html_components/dash_html_components.min.js.map",
                    dynamic = true,
                    async = nothing,
                    type = :js
                )
            ]
        )
    )
    @test length(DashBase.main_registry().components) == 1
end
