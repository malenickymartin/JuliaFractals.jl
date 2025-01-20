function gpu_fractal_kernel!(
    result::AbstractArray{<:Integer}, func::Function, params::AbstractArray{<:Number},
    x_vals::AbstractArray{<:AbstractFloat}, y_vals::AbstractArray{<:AbstractFloat}
)
    i = threadIdx().x + (blockIdx().x - 1) * blockDim().x
    j = threadIdx().y + (blockIdx().y - 1) * blockDim().y
    if i <= size(result, 1) && j <= size(result, 2)
        @inbounds result[i, j] = func(x_vals[i], y_vals[j], params)
    end
    return
end

function plane_ranges(
    center::AbstractVector{<:AbstractFloat}, size::AbstractVector{<:AbstractFloat},
    img_size::AbstractVector{<:Integer}
)
    img_width, img_height = img_size
    x_scale = size[1] / (img_width - 1)
    y_scale = size[2] / (img_height - 1)
    x_range = [center[1] - size[1]/2 + x_scale * (i - 1) for i in 1:img_width]
    y_range = [center[2] - size[2]/2 + y_scale * (j - 1) for j in 1:img_height]
    return x_range, y_range
end

function compute_fractal_gpu(
    func::Function, params::AbstractArray{<:Number}, center::AbstractVector{<:AbstractFloat},
    plane_size::AbstractVector{<:AbstractFloat}, img_size::AbstractVector{<:Integer}
)
    x_range, y_range = plane_ranges(center, plane_size, img_size)
    cuda_x_range = CuArray(x_range)
    cuda_y_range = CuArray(y_range)
    cuda_params = CuArray(params)
    result = CUDA.zeros(UInt8, img_size...)

    threads = (32, 32)
    blocks = (cld(img_size[1], threads[1]), cld(img_size[2], threads[2]))
    @cuda threads=threads blocks=blocks gpu_fractal_kernel!(result, func, cuda_params, cuda_x_range, cuda_y_range)
    return result
end

function cpu_fractal_kernel!(
    result::AbstractArray{UInt8,2}, func::Function, params::AbstractArray{<:Number},
    x_range::AbstractVector{<:AbstractFloat}, y_range::AbstractVector{<:AbstractFloat}, 
    img_width::Integer
)
    if img_width/Threads.nthreads()-1 < length(x_range)
        x_center = length(x_range) ÷ 2
        finish = Threads.@spawn cpu_fractal_kernel!(result, func, params, x_range[1:x_center], y_range, img_width)
        cpu_fractal_kernel!(result, func, params, x_range[x_center+1:end], y_range, img_width)
        wait(finish)
    else
        for i in eachindex(x_range)
            for j in eachindex(y_range)
                @inbounds result[j, i] = func(x_range[i], y_range[j], params)
            end
        end
    end
end

function compute_fractal_cpu(
    func::Function, params::AbstractArray{<:Number}, center::AbstractVector{<:AbstractFloat},
    plane_size::AbstractVector{<:AbstractFloat}, img_size::AbstractVector{<:Integer}
)
    x_range, y_range = plane_ranges(center, plane_size, img_size)
    result = Array{UInt8,2}(undef,reverse(img_size)...)
    cpu_fractal_kernel!(result, func, params, x_range, y_range, img_size[1])
    return result
end

"""
    compute_fractal(func, params, center, plane_size, img_size, use_gpu=true)

Compute a fractal using the given function and parameters.

# Arguments
- `func::Function`: The function to compute the fractal with.
- `params::AbstractArray{<:Number}`: The parameters to pass to the function.
- `center::AbstractVector{<:AbstractFloat}`: The center of the complex plane in image.
- `plane_size::AbstractVector{<:AbstractFloat}`: The size of the complex plane.
- `img_size::AbstractVector{<:Integer}`: The size of the image.
- `use_gpu::Bool=true`: Whether to use the GPU or threaded CPU for computation.

# Returns
An `Array{UInt8,2}` containing the computed fractal.
"""
function compute_fractal(
    func::Function, params::AbstractArray{<:Number}, center::AbstractVector{<:AbstractFloat},
    plane_size::AbstractVector{<:AbstractFloat}, img_size::AbstractVector{<:Integer}, use_gpu::Bool=true
)
    if CUDA.has_cuda() && use_gpu
        return Array(compute_fractal_gpu(func, params, center, plane_size, img_size))
    else
        return compute_fractal_cpu(func, params, center, plane_size, img_size)
    end
end