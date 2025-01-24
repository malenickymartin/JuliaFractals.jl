function axes_bounds(center, plane_size)
    x_start_stop = (center[1]-plane_size[1], center[1]+plane_size[1])
    y_start_stop = (center[2]-plane_size[2], center[2]+plane_size[2])
    return x_start_stop, y_start_stop
end

function matrix_to_img(matrix)
    return reverse(transpose(matrix), dims=2)
end

function animate_fractal(func, params, center, plane_size, img_size, fps=30)
    fig, ax, im = image(
        axes_bounds(center, plane_size)..., 
        axis = (xlabel="Real", ylabel="Imaginary"), matrix_to_img(compute_fractal(func, params, center, plane_size, img_size)))
    display(fig)
    for _ in 1:100
        plane_size *= 0.99
        im[1], im[2] = axes_bounds(center, plane_size)
        autolimits!(ax)
        im[3] = matrix_to_img(compute_fractal(func, params, center, plane_size, img_size))
        sleep(1/fps)
    end
end

function create_plotter(size_x, size_y)
    fig = Figure(size = (size_x, size_y))
    ax = fig[1,1] = Axis(fig, xlabel="Real", ylabel="Imaginary")
    function my_plot(img)
        img = matrix_to_img(img)
        heatmap!(ax, img)
        display(fig)
    end
end

function basic_plot(func, params, center, plane_size, img_size)
    img = matrix_to_img(compute_fractal(func, params, center, plane_size, img_size, false))
    fig, ax, im = heatmap(axes_bounds(center, plane_size)..., axis = (xlabel="Real", ylabel="Imaginary"), img)
    display(fig)
end