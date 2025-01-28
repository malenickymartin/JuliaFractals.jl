"""
    gpu_fractal_kernel!(result, func, params, x_vals, y_vals)

A kernel for computing a fractal on the GPU.

# Arguments
- `result::AbstractArray{<:Integer}`: The array to store the computed fractal.
- `func::Function`: The function to compute the fractal with.
- `params::AbstractArray{<:Number}`: The parameters to pass to the function.
- `x_vals::AbstractArray{<:Real}`: The x values of the complex plane.
- `y_vals::AbstractArray{<:Real}`: The y values of the complex plane.
"""
function gpu_fractal_kernel!(
    result::AbstractArray{<:Integer}, func::Function, params::AbstractArray{<:Number},
    x_vals::AbstractArray{<:Real}, y_vals::AbstractArray{<:Real}
)
    i = threadIdx().y + (blockIdx().y - 1) * blockDim().y
    j = threadIdx().x + (blockIdx().x - 1) * blockDim().x
    if i <= size(result, 1) && j <= size(result, 2)
        @inbounds result[i, j] = func(x_vals[j], y_vals[i], params)
    end
    return
end

"""
    plane_ranges(center, size, img_size)

Compute the ranges of the complex plane in image coordinates.

# Arguments
- `center::AbstractVector{<:Real}`: The center of the complex plane in image.
- `size::AbstractVector{<:Real}`: The size of the complex plane.
- `img_size::AbstractVector{<:Integer}`: The size of the image.

# Returns
A tuple of two arrays containing the x and y ranges of the complex plane.
"""
function plane_ranges(
    center::AbstractVector{<:Real}, plane_size::AbstractVector{<:Real},
    img_size::AbstractVector{<:Integer}
)
    img_width, img_height = img_size
    x_scale = plane_size[1] / (img_width - 1)
    y_scale = plane_size[2] / (img_height - 1)
    x_range = [center[1] - plane_size[1]/2 + x_scale * (i - 1) for i in 1:img_width]
    y_range = [center[2] - plane_size[2]/2 + y_scale * (j - 1) for j in 1:img_height]
    return x_range, y_range
end

"""
    compute_fractal_gpu(func, params, center, plane_size, img_size)

Compute a fractal using the given function and parameters on the GPU.

# Arguments
- `func::Function`: The function to compute the fractal with.
- `params::AbstractArray{<:Number}`: The parameters to pass to the function.
- `center::AbstractVector{<:Real}`: The center of the complex plane in image.
- `plane_size::AbstractVector{<:Real}`: The size of the complex plane.
- `img_size::AbstractVector{<:Integer}`: The size of the image.

# Returns
An `Array{UInt16,2}` containing the computed fractal.
"""
function compute_fractal_gpu(
    func::Function, params::AbstractArray{<:Number}, center::AbstractVector{<:Real},
    plane_size::AbstractVector{<:Real}, img_size::AbstractVector{<:Integer}
)
    x_range, y_range = plane_ranges(center, plane_size, img_size)
    cuda_x_range = CuArray(x_range)
    cuda_y_range = CuArray(y_range)
    cuda_params = CuArray(params)
    result = CUDA.zeros(UInt16, reverse(img_size)...)

    max_th = CUDA.attribute(device(), CUDA.DEVICE_ATTRIBUTE_MAX_THREADS_PER_BLOCK)
    th_x = min(max_th, img_size[1])
    th_y = min(max_th ÷ th_x, img_size[2])
    blocks = (cld(img_size[1], th_x), cld(img_size[2], th_y))
    @cuda threads=(th_x, th_y) blocks=blocks gpu_fractal_kernel!(result, func, cuda_params, cuda_x_range, cuda_y_range)
    return result
end

"""
    compute_fractal_cpu(func, params, center, plane_size, img_size)

Compute a fractal using the given function and parameters on the CPU.

# Arguments
- `func::Function`: The function to compute the fractal with.
- `params::AbstractArray{<:Number}`: The parameters to pass to the function.
- `center::AbstractVector{<:Real}`: The center of the complex plane in image.
- `plane_size::AbstractVector{<:Real}`: The size of the complex plane.
- `img_size::AbstractVector{<:Integer}`: The size of the image.

# Returns
An `Array{UInt16,2}` containing the computed fractal.
"""
function compute_fractal_cpu(
    func::Function, params::AbstractArray{<:Number}, center::AbstractVector{<:Real},
    plane_size::AbstractVector{<:Real}, img_size::AbstractVector{<:Integer}
)
    x_range, y_range = plane_ranges(center, plane_size, img_size)
    result = Array{UInt16,2}(undef, reverse(img_size)...)
    @floop ThreadedEx(basesize=img_size[1]÷(Threads.nthreads()^2)) for i in eachindex(x_range)
        for j in eachindex(y_range)
            @inbounds result[j, i] = func(x_range[i], y_range[j], params)
        end
    end
    return result
end

"""
    compute_fractal(func, params, center, plane_size, img_size, use_gpu=true)

Compute a fractal using the given function and parameters.

# Arguments
- `func::Function`: The function to compute the fractal with.
- `params::AbstractArray{<:Number}`: The parameters to pass to the function.
- `center::AbstractVector{<:Real}`: The center of the complex plane in image.
- `plane_size::AbstractVector{<:Real}`: The size of the complex plane.
- `img_size::AbstractVector{<:Integer}`: The size of the image.
- `use_gpu::Bool=true`: Whether to use the GPU or threaded CPU for computation.

# Returns
An `Array{UInt16,2}` containing the computed fractal.
"""
function compute_fractal(
    func::Function, params::AbstractArray{<:Number}, center::AbstractVector{<:Real},
    plane_size::AbstractVector{<:Real}, img_size::AbstractVector{<:Integer}, use_gpu::Bool=true
)
    if CUDA.has_cuda() && use_gpu
        return Array(compute_fractal_gpu(func, params, center, plane_size, img_size))
    else
        return compute_fractal_cpu(func, params, center, plane_size, img_size)
    end
end

"""
    # fractal_closure(func::Function)

Create a closure for computing fractals with the given function and parameters.

# Arguments
- `func::Function`: The function to compute the fractal with.
- `img_size::AbstractVector{<:Integer}`: The size of the image.
- `use_gpu::Bool=true`: Whether to use the GPU or threaded CPU for computation.

# Returns
A closure that computes a fractal using the given function with parameters: parameters, center, and plane size.
"""
function fractal_closure(func::Function, img_size::AbstractVector{<:Integer}, use_gpu::Bool=true)
    return (params, center, plane_size) -> compute_fractal(func, params, center, plane_size, img_size, use_gpu)
end