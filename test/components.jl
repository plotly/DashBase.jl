using DashBase
using JSON3

@testset "components creation" begin
    test_comp = Component("html_div", "Div", "dash_html_components",
        [:children, :id, :n_clicks],
        [Symbol("data-"), Symbol("aria-")];
        id=10,
        n_clicks=1
    )

    @test get_name(test_comp) == "html_div"
    @test get_type(test_comp) == "Div"
    @test get_namespace(test_comp) == "dash_html_components"
    @test test_comp.id == 10
    @test test_comp.n_clicks == 1
    test_comp.var"data-id" = 20
    @test test_comp.var"data-id" == 20

    @test sort(propertynames(test_comp)) == sort([:children, :id, :n_clicks])
    @test isnothing(test_comp.children)

    #anavailable property
    @test_throws ErrorException test_comp.key
    @test_throws ErrorException test_comp.key = 20
    @test_throws ErrorException Component("html_div", "Div", "dash_html_components",
        [:children, :id, :n_clicks],
        [Symbol("data-"), Symbol("aria-")];
        id=10,
        key=1
    )
    json = JSON3.write(test_comp)
    res = JSON3.read(json)
    @test all(keys(res) .== [:type, :namespace, :props])
    @test sort(collect(keys(res.props))) == sort([:id, :n_clicks, Symbol("data-id")])
    @test res.props.id == 10
    @test res.props.n_clicks == 1
    @test res.props.var"data-id" == 20
end

@testset "empty wilds" begin
    test_comp = Component("html_div", "Div", "dash_html_components",
        [:children, :id, :n_clicks],
        Symbol[];
        id=10,
        n_clicks=1
    )

    @test get_name(test_comp) == "html_div"
    @test get_type(test_comp) == "Div"
    @test get_namespace(test_comp) == "dash_html_components"
    @test test_comp.id == 10
    @test test_comp.n_clicks == 1

    @test_throws ErrorException test_comp.var"data-id" = 20
    @test_throws ErrorException test_comp.aaaaa
end
function test_component(; kwargs...)
    Component("html_div", "Div", "dash_html_components", [:dir, :n_clicks, :key, :loading_state, :contentEditable, :contextMenu, :n_clicks_timestamp, :draggable, :accessKey, :hidden, :style, :children, :id, :title, :role, :lang, :spellCheck, :tabIndex, :disable_n_clicks, :className], Symbol[]; kwargs...)
end
@testset "Index by id" begin
    layout = test_component(children=[
        test_component(id="my-id", n_clicks=0, title="text"),
        test_component(id="my-div", children=[
            test_component(children=[]),
            "string",
            test_component(id="target")
        ]),
        test_component(id="my-div2")
    ])
    @test layout["target"].id == "target"
    @test layout["ups"] === nothing
end
