### Max Loading w/ Discrete Variables

@testset "test ac ml uc" begin
    @testset "3-bus case" begin
        result = run_mld_uc(case3_mld, ACPPowerModel, juniper_solver)

        #println(result["objective"])
        @test result["status"] == :LocalOptimal
        @test isapprox(result["objective"], 321.03430048623324; atol = 1e-2)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 1.0343425523566503; atol = 1e-1)
        @test all_gens_on(result)
        @test all_voltages_on(result)
    end
    @testset "3-bus uc case" begin
        result = run_mld_uc(case3_mld_uc, ACPPowerModel, juniper_solver)

        #println(result["objective"])
        @test result["status"] == :LocalOptimal
        @test isapprox(result["objective"], 310.500000019965; atol = 1e-2)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 0.5000000199653287; atol = 1e-1)
        @test isapprox(gen_status(result, "1"), 0.000000; atol = 1e-6)
        @test isapprox(gen_status(result, "2"), 1.000000; atol = 1e-6)
        @test all_voltages_on(result)
    end
    #=
    # does not converge with Juniper v0.2
    @testset "3-bus line charge case" begin
        result = run_mld_uc(case3_mld_lc, ACPPowerModel, juniper_solver)

        #println(result["objective"])
        @test result["status"] == :LocalOptimal
        @test isapprox(result["objective"], 0.0; atol = 1e-2)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 0.0; atol = 1e-1)
        @test all_gens_on(result)
        #println([bus["status"] for (i,bus) in result["solution"]["bus"]])
        @test isapprox(bus_status(result, "1"), 0.0; atol = 1e-4)
        @test isapprox(bus_status(result, "2"), 0.0; atol = 1e-4)
        @test isapprox(bus_status(result, "3"), 0.0; atol = 1e-4)
    end
    =#
    @testset "24-bus rts case" begin
        result = run_mld_uc(case24, ACPPowerModel, juniper_solver)

        #println(result["objective"])
        @test result["status"] == :LocalOptimal
        @test isapprox(result["objective"], 9152.69940869897; atol = 1e-1)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 28.49984472637877; atol = 1e-0)
        @test all_gens_on(result)
        @test all_voltages_on(result)
    end
end


@testset "test dc ml uc" begin
    @testset "3-bus case" begin
        result = run_mld_uc(case3_mld, DCPPowerModel, cbc_solver)

        #println(result["objective"])
        @test result["status"] == :Optimal
        @test isapprox(result["objective"], 21.1582; atol = 1e-2)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 1.1582177246877814; atol = 1e-1)
        @test all_gens_on(result)
    end
    @testset "3-bus uc case" begin
        result = run_mld_uc(case3_mld_uc, DCPPowerModel, cbc_solver)

        #println(result["objective"])
        @test result["status"] == :Optimal
        @test isapprox(result["objective"], 10.5; atol = 1e-2)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 0.500; atol = 1e-1)
        @test isapprox(gen_status(result, "1"), 0.000000; atol = 1e-6)
        @test isapprox(gen_status(result, "2"), 1.000000; atol = 1e-6)
    end
    @testset "3-bus line charge case" begin
        result = run_mld_uc(case3_mld_lc, DCPPowerModel, cbc_solver)

        #println(result["objective"])
        @test result["status"] == :Optimal
        @test isapprox(result["objective"], 10.58051219078263; atol = 1e-2)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 0.58051219078262775; atol = 1e-1)
        @test all_gens_on(result)
    end
    @testset "24-bus rts case" begin
        result = run_mld_uc(case24, DCPPowerModel, cbc_solver)

        #println(result["objective"])
        @test result["status"] == :Optimal
        @test isapprox(result["objective"], 1160.653542372048; atol = 1e-2)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 28.45354237204865; atol = 1e-0)
        @test all_gens_on(result)
    end
end


# these tests were commented out in the old code
@testset "test soc ml uc" begin
    @testset "3-bus case" begin
        result = run_mld_uc(case3_mld, SOCWRPowerModel, pavito_solver)

        #println(result["objective"])
        @test result["status"] == :Optimal
        @test isapprox(result["objective"], 321.2196376243908; atol = 1e-2)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 1.2196381783402782; atol = 1e-1)
        @test all_gens_on(result)
        @test all_voltages_on(result)
    end
    @testset "3-bus uc case" begin
        result = run_mld_uc(case3_mld_uc, SOCWRPowerModel, pavito_solver)

        #println(result["objective"])
        @test result["status"] == :Optimal
        @test isapprox(result["objective"], 310.4999991455502; atol = 1e-2)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 0.49999951695198455; atol = 1e-1)
        @test isapprox(gen_status(result, "1"), 0.000000; atol = 1e-6)
        @test isapprox(gen_status(result, "2"), 1.000000; atol = 1e-6)
        @test all_voltages_on(result)
    end
    # pajarito v0.4.2 is reporting infeasible while gurobi produces a correct answer
    #=
    @testset "3-bus line charge case" begin
        result = run_mld_uc(case3_mld_lc, SOCWRPowerModel, pavito_solver)

        #println(result["objective"])
        @test result["status"] == :LocalOptimal
        @test isapprox(result["objective"], 40.0; atol = 1e-2)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 0.0; atol = 1e-1)
        @test all_gens_on(result)
        #println([bus["status"] for (i,bus) in result["solution"]["bus"]])
        @test isapprox(bus_status(result, "1"), 0.0; atol = 1e-4)
        @test isapprox(bus_status(result, "2"), 0.0; atol = 1e-4)
        @test isapprox(bus_status(result, "3"), 0.0; atol = 1e-4)
    end
    =#
    @testset "24-bus rts case" begin
        result = run_mld_uc(case24, SOCWRPowerModel, pavito_solver)

        #println(result["objective"])
        @test result["status"] == :Optimal
        @test isapprox(result["objective"], 9152.699998997845; atol = 1e-2)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result),  28.49999876239111; atol = 1e-0)
        @test all_gens_on(result)
        @test all_voltages_on(result)
    end
end

# stop supporting QC because bus voltage on/off is tedious to implement
#=
@testset "test qc ml uc" begin
    @testset "3-bus case" begin
        result = run_mld_uc(case3_mld, QCWRPowerModel, pavito_solver)

        #println(result["objective"])
        @test result["status"] == :Optimal
        @test isapprox(result["objective"], 51.118520841468644; atol = 1e-2)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 1.1185212567455372; atol = 1e-1)
        @test all_gens_on(result)
        @test all_voltages_on(result)
    end
    @testset "3-bus uc case" begin
        result = run_mld_uc(case3_mld_uc, QCWRPowerModel, pavito_solver)

        #println(result["objective"])
        @test result["status"] == :Optimal
        @test isapprox(result["objective"], 40.49999880734695; atol = 1e-2)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 0.4999992438191713; atol = 1e-1)
        @test isapprox(gen_status(result, "1"), 0.000000; atol = 1e-6)
        @test isapprox(gen_status(result, "2"), 1.000000; atol = 1e-6)
        @test all_voltages_on(result)
    end
    @testset "3-bus line charge case" begin
        result = run_mld_uc(case3_mld_lc, QCWRPowerModel, pavito_solver)

        println(result["objective"])
        @test result["status"] == :LocalOptimal
        #@test isapprox(result["objective"], 219.6761747108187; atol = 1e-2)
        println("active power: $(active_power_served(result))")
        #@test isapprox(active_power_served(result), 0.008694494772611786; atol = 1e-1)
        @test all_gens_on(result)
        println([bus["status"] for (i,bus) in result["solution"]["bus"]])
        #@test isapprox(bus_status(result, "1"), 1.0; atol = 1e-4)
        #@test isapprox(bus_status(result, "2"), 0.796675; atol = 1e-2)
        #@test isapprox(bus_status(result, "3"), 1.02784e-8; atol = 1e-2)
    end
    @testset "24-bus rts case" begin
        result = run_mld_uc(case24, QCWRPowerModel, pavito_solver)

        #println(result["objective"])
        @test result["status"] == :Optimal
        @test isapprox(result["objective"], 1926.6000024180994; atol = 1e-2)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 28.499998815454937; atol = 1e-1)
        @test all_gens_on(result)
        @test all_voltages_on(result)
    end
end
=#

# these tests were not tested in the old code
# these tests are not a relaxation of the AC!
@testset "test sdp ml uc" begin
    #=
    @testset "3-bus case" begin
        result = run_mld_uc(case3_mld, SDPWRMPowerModel, pajarito_sdp_solver)

        #println(result["objective"])
        @test result["status"] == :Optimal
        @test isapprox(result["objective"], 321.0344007505233; atol = 1e-1)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 1.0344007505232645; atol = 1e-1)
        @test all_gens_on(result)
        @test all_voltages_on(result)
    end
    =#
    @testset "3-bus uc case" begin
        result = run_mld_uc(case3_mld_uc, SDPWRMPowerModel, pajarito_sdp_solver)

        #println(result["objective"])
        @test result["status"] == :Optimal
        @test isapprox(result["objective"], 310.5; atol = 1e-1)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 0.500000000000036; atol = 1e-1)
        @test isapprox(gen_status(result, "1"), 0.000000; atol = 1e-6)
        @test isapprox(gen_status(result, "2"), 1.000000; atol = 1e-6)
        @test all_voltages_on(result)
    end
    @testset "3-bus line charge case" begin
        result = run_mld_uc(case3_mld_lc, SDPWRMPowerModel, pajarito_sdp_solver)

        #println(result["objective"])
        @test result["status"] == :Optimal
        @test isapprox(result["objective"], 10.0000; atol = 1e-2)
        #println("active power: $(active_power_served(result))")
        @test isapprox(active_power_served(result), 0.0; atol = 1e-1)
        @test all_gens_on(result)
        #println([bus["status"] for (i,bus) in result["solution"]["bus"]])
        @test isapprox(bus_status(result, "1"), 0.0; atol = 1e-4)
        @test isapprox(bus_status(result, "2"), 0.0; atol = 1e-4)
        @test isapprox(bus_status(result, "3"), 0.0; atol = 1e-4)
    end
    # TODO replace this with smaller case, way too slow for unit testing
    #@testset "24-bus rts case" begin
    #    result = run_mld_uc(case24, SDPWRMPowerModel, pajarito_sdp_solver)

    #    println(result["objective"])
    #    @test result["status"] == :Optimal
    #    @test isapprox(result["objective"], 75153; atol = 1e0)
    #end
end