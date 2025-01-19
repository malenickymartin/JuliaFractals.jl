function animate_juliaset()
    fig = Figure(size = (800, 800))
    ax = Axis(fig[1, 1])
    img = juliaset(1, 0, 1000)
    julia_plot = heatmap!(ax, Array(img), colormap = :viridis)

    display(fig)

    for t in 0:1000
        dt = @elapsed begin
            x = 0.7885 * cos(2π*t/1000)
            y = 0.7885 * sin(2π*t/1000)
            img = juliaset(x, y, 1000)
            julia_plot[1] = Array(img)
        end
        sleep(max(0, 1/60 - dt))
    end
end