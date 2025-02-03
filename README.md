# JuliaFractals
<div align="center">

[![In development documentation](https://img.shields.io/badge/docs-dev-blue.svg)](https://malenickymartin.github.io/JuliaFractals.jl/dev)
[![Docs workflow Status](https://github.com/malenickymartin/JuliaFractals.jl/actions/workflows/Docs.yml/badge.svg?branch=main)](https://github.com/malenickymartin/JuliaFractals.jl/actions/workflows/Docs.yml?query=branch%3Amain)
[![Test workflow status](https://github.com/malenickymartin/JuliaFractals.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/malenickymartin/JuliaFractals.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/malenickymartin/JuliaFractals.jl/blob/master/LICENSE)
[![codecov](https://codecov.io/gh/malenickymartin/JuliaFractals.jl/graph/badge.svg?token=GHSAKYW2KY)](https://codecov.io/gh/malenickymartin/JuliaFractals.jl)

</div>

Welcome to the documentation of JuliaFractals.jl. This package provides a simple interface to compute and visualize fractals using the Julia programming language, 
leveraging its power for high-performance computations.

## Installation

To install the package, run the following command in the Julia REPL:

```
using Pkg
Pkg.add(url="https://github.com/malenickymartin/JuliaFractals.git")
```

## Features

- **Easy-to-use API**: Simple and intuitive functions to generate fractals.
- **Real-time Animation**: Capable of generating real-time animations of fractals.
- **High Performance**: Utilizes Julia's high-performance capabilities to compute fractals efficiently.
- **Customizable**: Supports a variety of fractal equations and parameters for customization.

## Getting Started

To get started with JuliaFractals, you can install the package and start generating fractals with just a few lines of code. Below is an example of how to compute a fractal using the `burningship_equation` with both GPU and CPU:

```@example
using JuliaFractals

compute_fractal(burningship_equation, [255], [0, 0], [3, 3], [10, 10])

compute_fractal(burningship_equation, [255], [0, 0], [3, 3], [10, 10], false)
```

The input function to the `compute_fractal` or `basic_plot` functions can be any function that takes x and y coordinates and a vector of arbitrary parameters, and outputs a `UInt16`. The output image created by calling the function on each pixel can be mapped on different color maps.

This example demonstrates how to generate a fractal image using the provided functions. You can customize the parameters to explore different fractal patterns and behaviors.
You can for example define your own fractal equation and use it:

```@example
using JuliaFractals

function my_equation(x, y, params)
    z = x + y*im
    c = params[1] + params[2]*im
    pixel_value = round(abs(5*z^2+x))
    return UInt16(pixel_value)
end

compute_fractal(my_equation, [255], [-1, -1], [1, 1], [10, 10])
```

Plotting the fractal is done as follows:

```@example
using JuliaFractals

basic_plot(burningship_equation, [255], [0, 0], [3, 3], [10, 10])
```

## Benchmarks

The following table shows the performance of the package for different fractal equations and resolutions on both GPU and CPU. The times are measured in milliseconds. The CPU times are measured for both single-core and multi-core (6 cores) performance. The benchmarks were run on an NVIDIA GeForce GTX 1650 GPU and an Intel Core i5-9300H CPU. The times for GPU include the time to transfer data to and from the GPU.

#### Mandelbrot:
| Resolution | Time (GPU) | Time (CPU 1 core) | Time (CPU 6 cores) |
|------------|:----------:|:-----------------:|:------------------:|
| 500x500    |  2.532     |     55.529        |      11.380        |
| 1000x1000  |  9.121     |     221.672       |      44.275        |
| 1500x1500  |  19.852    |     501.976       |      98.538        |

#### Burning Ship:
| Resolution | Time (GPU) | Time (CPU 1 core) | Time (CPU 6 cores) |
|------------|:----------:|:-----------------:|:------------------:|
| 500x500    |  2.629     |     59.215        |     11.879         |
| 1000x1000  |  9.350     |     237.025       |     46.240         |
| 1500x1500  |  20.268    |     535.690       |     102.591        |

#### Newton (x<sup>3</sup>-1):
| Resolution | Time (GPU) | Time (CPU 1 core) | Time (CPU 6 cores) |
|------------|:----------:|:-----------------:|:------------------:|
| 500x500    |  53.690    |     1301          |        244.407     |
| 1000x1000  |  195.101   |     5235          |        973.767     |
| 1500x1500  |  425.482   |     11772         |        2188        |