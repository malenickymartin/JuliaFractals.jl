@testset "GPU_CPU_Computation" begin
    for _ in 1:20
        params = [rand(1:255)]
        center = rand(-2:0.1:2, 2)
        plane_size = rand(0.5:0.1:5.0, 2)
        img_size = rand(100:2000, 2)
        cpu_result = SPJFractals.compute_fractal_cpu(mandelbrot_equation, params, center, plane_size, img_size)
        cpu_result_generic = compute_fractal(mandelbrot_equation, params, center, plane_size, img_size, false)
        if CUDA.has_cuda()
            gpu_result = Array(SPJFractals.compute_fractal_gpu(mandelbrot_equation, params, center, plane_size, img_size))
            gpu_result_generic = compute_fractal(mandelbrot_equation, params, center, plane_size, img_size, true)
            @test cpu_result == gpu_result == cpu_result_generic == gpu_result_generic
        else
            @test cpu_result == cpu_result_generic
        end
    end
end
