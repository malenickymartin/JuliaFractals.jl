```@meta
CurrentModule = SPJFractals
```

# SPJFractals

Welcome to the documentation of SPJFractals.jl. This package provides a simple interface to compute and visualize fractals using the Julia programming language, 
leveraging its power for high-performance computations.

## Installation

To install the package, run the following command in the Julia REPL:

```
using Pkg
Pkg.add(url="https://github.com/malenickymartin/SPJFractals.git")
```

## Features

- **Easy-to-use API**: Simple and intuitive functions to generate fractals.
- **Real-time Animation**: Capable of generating real-time animations of fractals.
- **High Performance**: Utilizes Julia's high-performance capabilities to compute fractals efficiently.
- **Customizable**: Supports a variety of fractal equations and parameters for customization.

## Getting Started

To get started with SPJFractals, you can install the package and start generating fractals with just a few lines of code. Below is an example of how to compute a fractal using the `burningship_equation` with both GPU and CPU:

```@example
using SPJFractals

compute_fractal(burningship_equation, [255], [0, 0], [3, 3], [10, 10])

compute_fractal(burningship_equation, [255], [0, 0], [3, 3], [10, 10], false)
```

The input function to the `compute_fractal` or `basic_plot` functions can be any function that takes x and y coordinates and a vector of arbitrary parameters, and outputs a `UInt16`. The output image created by calling the function on each pixel can be mapped on different color maps.

This example demonstrates how to generate a fractal image using the provided functions. You can customize the parameters to explore different fractal patterns and behaviors.
You can for example define your own fractal equation and use it:

```@example
using SPJFractals

function my_equation(x, y, params)
    z = x + y*im
    c = params[1] + params[2]*im
    pixel_value = round(abs(5*z^2+x))
    return UInt16(pixel_value)
end

compute_fractal(my_equation, [1, 1], [0, 0], [1, 1], [10, 10])
```

Plotting the fractal is done as follows:

```@example
using SPJFractals

basic_plot(burningship_equation, [255], [0, 0], [3, 3], [10, 10])
```

## Benchmarks

Tabulka CPU vs CUDA vs CUDA s bez převodu obrázku na CPU | velikost obrázku
Benchmark script zde