using Aqua
using DashBase
using Test

# skip `stale_deps` for newer version, as
# we no longer load Requires
stale_deps = VERSION < v"1.9.0"

Aqua.test_all(DashBase; stale_deps)

if !stale_deps
    @testset "test_stale_deps except for Requires" begin
        Aqua.test_stale_deps(DashBase; ignore=[:Requires])
    end
end
