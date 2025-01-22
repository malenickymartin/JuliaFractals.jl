@testset verbose=true "mandelbrot_equation" begin
    params = [255.0]
    @testset "In points" begin
        @test mandelbrot_equation(0.0, 0.0, params) == params[1]
        @test mandelbrot_equation(-1.0, 0.0, params) == params[1]
        @test mandelbrot_equation(0.0, -1.0, params) == params[1]
        @test mandelbrot_equation(0.0, 1.0, params) == params[1]
    end
    @testset "Out points" begin
        @test mandelbrot_equation(1.0, 0.0, params) < params[1]
        @test mandelbrot_equation(-1.0, 1.0, params) < params[1]
        @test mandelbrot_equation(-1.0, -1.0, params) < params[1]
        @test mandelbrot_equation(0.5, 0.0, params) < params[1]
    end
end

@testset verbose=true "julia_equation" begin
    params = [255.0, 0.0, 0.0]
    @testset "In points" begin
        @test julia_equation(0.0, 0.0, params) == params[1]
        @test julia_equation(-1.0, 0.0, params) == params[1]
        @test julia_equation(0.0, -1.0, params) == params[1]
        @test julia_equation(0.0, 1.0, params) == params[1]
    end
    @testset "Out points" begin
        @test julia_equation(2.0, 0.0, params) < params[1]
        @test julia_equation(-2.0, 0.0, params) < params[1]
        @test julia_equation(0.0, 2.0, params) < params[1]
        @test julia_equation(0.0, -2.0, params) < params[1]
    end
end