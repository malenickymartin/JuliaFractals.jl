"""
    mandelbrot_equation(x::AbstractFloat, y::AbstractFloat, params::AbstractVector{<:Real})

Compute the number of iterations for the Mandelbrot set equation.

# Arguments
- `x::AbstractFloat`: The x-coordinate of the point.
- `y::AbstractFloat`: The y-coordinate of the point.
- `params::AbstractVector{<:Real}`: Number of iterations.

# Returns
The number of iterations before the point escapes.
"""
function mandelbrot_equation(x::AbstractFloat, y::AbstractFloat, params::AbstractVector{<:Real})
    max_iter = params[1]
    c = ComplexF64(x, -y)
    z = ComplexF64(0, 0)
    iter = UInt16(0)
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
- `params::AbstractVector{<:Real}`: Number of iterations, complex part of the constant, and real part of the constant.

# Returns
The number of iterations before the point escapes.
"""
function julia_equation(x0::AbstractFloat, y0::AbstractFloat, params::AbstractVector{<:Real} = [500, 0.0, 0.0])
    c_x = params[2]
    c_y = params[3]
    x = x0
    y = -y0
    x2 = x0*x0
    y2 = y0*y0
    for i in 1:params[1]
        if x2 + y2 > 4.0
            return UInt16(i)
        end
        y = 2*x*y + c_y
        x = x2 - y2 + c_x
        x2 = x*x
        y2 = y*y
    end
    return UInt16(params[1])
end

"""
    burning_ship_equation(x::AbstractFloat, y::AbstractFloat, params::AbstractVector{<:Real})

Compute the number of iterations for the Burning Ship fractal equation.

# Arguments
- `x::AbstractFloat`: The x-coordinate of the point.
- `y::AbstractFloat`: The y-coordinate of the point.
- `params::AbstractVector{<:Real}`: Number of iterations.

# Returns
The number of iterations before the point escapes.
"""
function burningship_equation(x::AbstractFloat, y::AbstractFloat, params::AbstractVector{<:Real})
    max_iter = params[1]
    c = ComplexF64(x, -y)
    z = ComplexF64(0, 0)
    iter = UInt16(0)
    while abs2(z) <= 4.0f0 && iter < max_iter
        z = ComplexF64(abs(real(z)), abs(imag(z)))^2 + c
        iter += 1
    end
    return UInt16(iter)
end

"""
    tricorn_equation(x::AbstractFloat, y::AbstractFloat, params::AbstractVector{<:Real})

Compute the number of iterations for the Tricorn fractal equation.

# Arguments
- `x::AbstractFloat`: The x-coordinate of the point.
- `y::AbstractFloat`: The y-coordinate of the point.
- `params::AbstractVector{<:Real}`: Number of iterations.

# Returns
The number of iterations before the point escapes.
"""
function tricorn_equation(x::AbstractFloat, y::AbstractFloat, params::AbstractVector{<:Real})
    max_iter = params[1]
    c = ComplexF64(x, -y)
    z = ComplexF64(0, 0)
    iter = UInt16(0)
    while abs2(z) <= 4.0f0 && iter < max_iter
        z = conj(z * z) + c
        iter += 1
    end
    return UInt16(iter)
end

"""
    create_newton_equation(func::Function)

Create a Newton fractal equation from a differentiable function f(x), solving f(x) = 0.
Each root is assigned a unique color based on the angle of the complex number.

# Arguments
- `func::Function`: The function to create the Newton fractal equation from.

# Returns
A function with input parameters x, y, and params, that computes the Newton fractal.
"""
function create_newton_equation(func::Function)
    @variables x
    update = eval(build_function(x - func(x) / Symbolics.derivative(func(x), x), x))
    function newton_equation(x::AbstractFloat, y::AbstractFloat, params::AbstractVector{<:Real})
        c = ComplexF64(x, -y)
        iters = params[1]
        final_iter = 0
        for i in 1:iters
            if abs2(c) < 1e-6
                final_iter = i
                break
            end
            c = update(c)
        end
        return UInt16(round(mod(rad2deg(angle(c)),360)))
    end
end


