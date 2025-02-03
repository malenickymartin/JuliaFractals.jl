@testset verbose = true "GPU CPU Computation" begin
    @testset "Image computation" begin
        for _ in 1:20
            params = [rand(1:255)]
            center = rand(-2:0.1:2, 2)
            plane_size = rand(0.5:0.1:5.0, 2)
            img_size = rand(100:2000, 2)
            closure = fractal_closure(mandelbrot_equation, img_size, false)
            closure_result = closure(params, center, plane_size)
            cpu_result = JuliaFractals.compute_fractal_cpu(mandelbrot_equation, params, center, plane_size, img_size)
            cpu_result_generic = compute_fractal(mandelbrot_equation, params, center, plane_size, img_size, false)
            if CUDA.functional()
                gpu_result = Array(JuliaFractals.compute_fractal_gpu(mandelbrot_equation, params, center, plane_size, img_size))
                gpu_result_generic = compute_fractal(mandelbrot_equation, params, center, plane_size, img_size, true)
                @test cpu_result == gpu_result == cpu_result_generic == gpu_result_generic == closure_result
            else
                @test cpu_result == cpu_result_generic
            end
        end
    end

    @testset "GPU kernel" begin
        if CUDA.functional()
            function dummy_fractal_func(x, y, params)
                return Int(x + y + sum(params))
            end
            result = CUDA.fill(0, 10, 10)
            params = CUDA.CuArray([1.0, 2.0])
            x_vals = CUDA.fill(1.0, 10)
            y_vals = CUDA.fill(1.0, 10)
            @cuda threads=(10, 10) JuliaFractals.gpu_fractal_kernel!(result, dummy_fractal_func, params, x_vals, y_vals)
            result_cpu = Array(result)
            for i in 1:10, j in 1:10
                @test result_cpu[i, j] == 2 + sum(params)
            end
        end
    end
end