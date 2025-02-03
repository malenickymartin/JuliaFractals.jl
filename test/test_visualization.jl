@testset "Visualization functions" begin
    @testset "axes_bounds" begin
        center = [0.0, 0.0]
        plane_size = [4.0, 4.0]
        x_bounds, y_bounds = JuliaFractals.axes_bounds(center, plane_size)
        @test x_bounds == (-2.0, 2.0)
        @test y_bounds == (-2.0, 2.0)
        center = [1.0, 1.0]
        plane_size = [2.0, 2.0]
        x_bounds, y_bounds = JuliaFractals.axes_bounds(center, plane_size)
        @test x_bounds == (0.0, 2.0)
        @test y_bounds == (0.0, 2.0)
    end

    @testset "basic_plot" begin
        func = mandelbrot_equation
        params = [255]
        center = [0.0, 0.0]
        plane_size = [4.0, 4.0]
        img_size = [10, 10]
        fig, img = basic_plot(func, params, center, plane_size, img_size)
        @test size(img) == (10, 10)
        @test typeof(fig.content) <: Vector
    end

    @testset "fractal_app" begin
        img_size = [1080, 720]
        fps = 60
        fractal_app(img_size, fps)
        @test true
    end
end