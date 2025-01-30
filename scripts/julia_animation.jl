using SPJFractals
using GLMakie

img_size = [1080, 720]
center = [0.0, 0.0]
plane_size = [4.0, 4.0 * 720 / 1080]
iterations = 100
radius = 0.7887
fps = 100
step_size = pi/180
julia_closure = fractal_closure(julia_equation, img_size, true)

fig = Figure(size = Tuple(img_size))
ax = Axis(fig[1, 1])
display(fig)

tau = 0.0
c_x = Observable(0.0)
c_y = Observable(0.0)
img = @lift(transpose(julia_closure([iterations, $c_x, $c_y], center, plane_size)))
heatmap!(ax, img)
while isopen(fig.scene)
    tau = (tau + step_size) % (2 * pi)
    c_x[] = radius * cos(tau)
    c_y[] = radius * sin(tau)
    sleep(1/fps)
end