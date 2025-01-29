"""
    axes_bounds(center, plane_size)

Compute the bounds of the axes for a heatmap.

# Arguments
- `center::AbstractVector{<:Real}`: The center of the complex plane in image.
- `plane_size::AbstractVector{<:Real}`: The size of the complex plane.

# Returns
A tuple of two tuples containing the x and y bounds of the axes.
"""
function axes_bounds(center, plane_size)
    x_start_stop = (center[1]-plane_size[1]/2, center[1]+plane_size[1]/2)
    y_start_stop = (center[2]-plane_size[2]/2, center[2]+plane_size[2]/2)
    return x_start_stop, y_start_stop
end

"""
    compute_fractal(func, params, center, plane_size, img_size, gpu)

Compute a fractal using the given function and parameters.

# Arguments
- `func::Function`: The function to compute the fractal with.
- `params::AbstractArray{<:Number}`: The parameters to pass to the function.
- `center::AbstractVector{<:Real}`: The center of the complex plane in image.
- `plane_size::AbstractVector{<:Real}`: The size of the complex plane.
- `img_size::AbstractVector{<:Integer}`: The size of the image.
- `gpu::Bool`: Whether to use the GPU for computation.

# Returns
An figure and image containing the computed fractal.
"""
function basic_plot(func, params, center, plane_size, img_size)
    img = transpose(compute_fractal(func, params, center, plane_size, img_size, false))
    fig, _, _ = heatmap(axes_bounds(center, plane_size)..., axis = (xlabel="Real", ylabel="Imaginary"), img)
    return fig, img
end

"""
    fractal_app(img_size::AbstractArray{<:Int} = [1080, 720], fps::Int = 60)

Create an interactive fractal visualization app.

# Arguments
- `img_size::AbstractArray{<:Int}`: The size of the image.
- `fps::Int`: The frames per second.

# Returns
Nothing.
"""
function fractal_app(img_size::AbstractArray{<:Int} = [1080, 720], fps::Int = 60)
    function make_fig(func, params, center, plane_size, img_size)
        fig = Figure(size = Tuple(img_size))
        display(fig)
        limits_x = @lift(axes_bounds($center, $plane_size)[1])
        limits_y = @lift(axes_bounds($center, $plane_size)[2])
        limits = @lift(($limits_x..., $limits_y...))
        ax = Axis(fig[1,1], limits = limits)
        hidedecorations!(ax, ticks = false)
        img = @lift(transpose(compute_fractal($func, $params, $center, $plane_size, img_size)))
        colormap = Observable("viridis")
        heatmap!(ax, limits_x, limits_y, img, colormap = colormap)
        return fig, img, colormap
    end
    function step!(img, func, params, center, plane_size, zoom, img_size)
        plane_size[] = plane_size[] * zoom[]
        img[] = transpose(compute_fractal(func[], params[], center[], plane_size[], img_size))
    end
    func = Observable{Function}(mandelbrot_equation)
    params = Observable{AbstractArray{<:Real}}([255])
    center = Observable{AbstractArray{<:Real}}([0.0, 0.0])
    plane_size = Observable{AbstractArray{<:Real}}([4.0, 4.0*img_size[2]/img_size[1]])
    zoom = Observable{Real}(1.0)
    fig, img, colormap = make_fig(func, params, center, plane_size, img_size)

    sliders_grid = SliderGrid(
        fig[2,1], 
        (label = "Zoom", range = -0.5:0.01:0.5, startvalue = 0.0),
        (label = "Iterations", range = 1:500, startvalue = 255)
    )

    on(sliders_grid.sliders[1].value) do x
        zoom[] = 1-x
    end

    on(sliders_grid.sliders[2].value) do x
        params[] = [x]
    end

    funcs = (mandelbrot_equation, burningship_equation, tricorn_equation)
    fig[3,1] = menu_grid = GridLayout()
    functions_menu, colormap_menu, run_button, reset_button = menu_grid[1, 1:4] = [
        Menu(fig, options = zip(("Mandelbrot", "Burning Ship", "Tricorn"), funcs), default = "Mandelbrot"),
        Menu(fig, options = ["viridis", "plasma", "inferno", "prism", "twilight"], default = "viridis"),
        Button(fig, label = "Run"),
        Button(fig, label = "Reset")
    ]

    on(functions_menu.selection) do x
            func[] = x
    end

    on(colormap_menu.selection) do s
        colormap[] = s
    end

    is_running = Observable(false)
    on(run_button.clicks) do _
        is_running[] = !is_running[]
        run_button.label[] = is_running[] ? "Stop" : "Run"
    end

    on(reset_button.clicks) do _
        center[] = [0.0, 0.0]
        plane_size[] = [4.0, 4.0*img_size[2]/img_size[1]]
        zoom[] = 1.0
        params[] = [255]
        colormap[] = "viridis"
        func[] = mandelbrot_equation
        is_running[] = false
        functions_menu.i_selected[] = 1
        colormap_menu.i_selected[] = 1
        sliders_grid.sliders[1].selected_index[] = 51
        sliders_grid.sliders[2].selected_index[] = 255
    end

    ax = content(fig[1,1])
    deactivate_interaction!(ax, :rectanglezoom)
    selected_point = select_point(ax.scene)
    on(selected_point) do p
        center[] = [p[1], p[2]]
    end

    on(run_button.clicks) do _
        @async while is_running[] && isopen(fig.scene)
            step!(img, func, params, center, plane_size, zoom, img_size)
            sleep(1/fps)
        end
    end
end