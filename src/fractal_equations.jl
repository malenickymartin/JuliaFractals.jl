"""
    mandelbrot_equation(x::AbstractFloat, y::AbstractFloat, params::AbstractVector{<:Real})

Compute the number of iterations for the Mandelbrot set equation.

# Arguments
- `x::AbstractFloat`: The x-coordinate of the point.
- `y::AbstractFloat`: The y-coordinate of the point.
- `params::AbstractVector{<:Real}`: The parameters of the equation.

# Returns
The number of iterations before the point escapes.
"""
function mandelbrot_equation(x::AbstractFloat, y::AbstractFloat, params::AbstractVector{<:Real})
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

"""
    julia_equation(x0::Real, y0::Real, params::AbstractVector{<:Real} = [500, 0.0, 0.0])

Compute the number of iterations for the Julia set equation.

# Arguments
- `x0::Real`: The x-coordinate of the point.
- `y0::Real`: The y-coordinate of the point.
- `params::AbstractVector{<:Real}`: The parameters of the equation.

# Returns
The number of iterations before the point escapes.
"""
function julia_equation(x0::Real, y0::Real, params::AbstractVector{<:Real} = [500, 0.0, 0.0])
    c_x = params[2]
    c_y = params[3]
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














