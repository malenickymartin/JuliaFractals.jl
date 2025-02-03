# Interactive App

## Introduction

The `fractal_app` function creates an interactive fractal visualization app. This app allows users to explore different fractal equations and visualize them in real-time.

```@docs; canonical=false
fractal_app
```

## Example

Here is an example of how to use the `fractal_app` function:

```@example
using JuliaFractals

# Create an interactive fractal visualization app with default parameters
fractal_app([1080, 720], 60)
```

## Controls

The interactive app provides the following controls:

- **Function Menu**: Select the fractal equation to visualize (e.g., Mandelbrot, Burning Ship, Tricorn).
- **Colormap Menu**: Choose the colormap for visualizing the fractal.
- **Run Button**: Start or stop the real-time fractal animation.
- **Reset Button**: Reset the fractal visualization to its initial state.
- **Sliders**: Adjust parameters such as zoom and iteration count.