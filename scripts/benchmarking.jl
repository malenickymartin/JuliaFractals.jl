using SPJFractals
using BenchmarkTools

function naive_mandelbrot(img_size)
    img = zeros(img_size...)
    for i in 1:img_size[1]
        for j in 1:img_size[2]
            x = 2.0 * (i - 1) / img_size[1] - 1.0
            y = 2.0 * (j - 1) / img_size[2] - 1.0
            c = ComplexF64(x, -y)
            z = ComplexF64(0, 0)
            iter = UInt16(0)
            while abs2(z) <= 4.0f0 && iter < 255
                z = z * z + c
                iter += 1
            end
            img[j, i] = iter
        end
    end
    return img
end

# Benchmark the GPU and CPU implementations on image size 500x500
println("GPU Img Size: 500x500")
display(@benchmark compute_fractal(mandelbrot_equation, [255], [0.0, 0.0], [2.0, 2.0], [500, 500], true))
println("CPU Img Size: 500x500")
display(@benchmark compute_fractal(mandelbrot_equation, [255], [0.0, 0.0], [2.0, 2.0], [500, 500], false))
println("Naive Img Size: 500x500")
display(@benchmark naive_mandelbrot([500, 500]))

# Benchmark the GPU and CPU implementations on image size 1000x1000
println("GPU Img Size: 1000x1000")
display(@benchmark compute_fractal(mandelbrot_equation, [255], [0.0, 0.0], [2.0, 2.0], [1000, 1000], true))
println("CPU Img Size: 1000x1000")
display(@benchmark compute_fractal(mandelbrot_equation, [255], [0.0, 0.0], [2.0, 2.0], [1000, 1000], false))
println("Naive Img Size: 1000x1000")
display(@benchmark naive_mandelbrot([1000, 1000]))

# Benchmark the GPU and CPU implementations on image size 1500x1500
println("GPU Img Size: 1500x1500")
display(@benchmark compute_fractal(mandelbrot_equation, [255], [0.0, 0.0], [2.0, 2.0], [1500, 1500], true))
println("CPU Img Size: 1500x1500")
display(@benchmark compute_fractal(mandelbrot_equation, [255], [0.0, 0.0], [2.0, 2.0], [1500, 1500], false))
println("Naive Img Size: 1500x1500")
display(@benchmark naive_mandelbrot([1500, 1500]))





