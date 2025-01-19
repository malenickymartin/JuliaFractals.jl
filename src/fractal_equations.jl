function mandelbrot(x::Float64, y::Float64, params::Vector{Float64})
    max_iter = params[1]
    c = ComplexF64(x, y)
    z = ComplexF64(0, 0)
    iter = 0
    while abs2(z) <= 4.0f0 && iter < max_iter
        z = z * z + c
        iter += 1
    end
    return iter
end

function julia(
    x0::T,
    y0::T,
    params::AbstractArray{Any, 1} = [500, 0.0, 0.0]
) where {T<:AbstractFloat}
    c_x = params[2] #float
    c_y = params[3] #float
    x = x0
    y = y0
    x2 = x0*x0
    y2 = y0*y0
    for i in 1:params[1]
        if x2 + y2 > 4.0
            return i
        end
        y = 2*x*y + c_y
        x = x2 - y2 + c_x
        x2 = x*x
        y2 = y*y
    end
    return params[1]
end














