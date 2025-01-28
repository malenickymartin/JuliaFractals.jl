@testset "mandelbrot_equation" begin
    params = [255]
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

@testset "julia_equation" begin
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

@testset "burningship_equation" begin
    params = [255]
    @testset "In points" begin
        @test burningship_equation(0.0, 0.0, params) == params[1]
        @test burningship_equation(-1.0, 0.0, params) == params[1]
        @test burningship_equation(-1.0, 1.0, params) == params[1]
        @test burningship_equation(0.0, 1.0, params) == params[1]
    end
    @testset "Out points" begin
        @test burningship_equation(1.0, 0.0, params) < params[1]
        @test burningship_equation(-1.0, -1.0, params) < params[1]
        @test burningship_equation(0.0, -1.0, params) < params[1]
        @test burningship_equation(0.5, 0.0, params) < params[1]
    end
end

@testset "tricorn_equation" begin
    params = [255]
    @testset "In points" begin
        @test tricorn_equation(0.0, 0.0, params) == params[1]
        @test tricorn_equation(-1.0, 0.0, params) == params[1]
        @test tricorn_equation(-2.0, 0.0, params) == params[1]
    end
    @testset "Out points" begin
        @test tricorn_equation(0.0, -1.0, params) < params[1]
        @test tricorn_equation(-1.0, -1.0, params) < params[1]
        @test tricorn_equation(1.0, 0.0, params) < params[1]
        @test tricorn_equation(-1.0, 1.0, params) < params[1]


    end
end

@testset "newton_equation" begin
    params = [255]
    f(x) = x^3 - 1
    newton_equation = create_newton_equation(f)
    @test newton_equation(1.0, 0.0, params) == round(mod(rad2deg(angle(1)),360))
    @test newton_equation(-1.0, 1.0, params) == round(mod(rad2deg(angle(-1/2-sqrt(3)/2*im)),360))
    @test newton_equation(-1.0, -1.0, params) == round(mod(rad2deg(angle(-1/2+sqrt(3)/2*im)),360))
end