# Base16.jl

Base16 theme generator based on [k-means clustering](https://en.wikipedia.org/wiki/K-means_clustering).

## About

The program takes an image and generates a [base16](http://www.chriskempson.com/projects/base16) based on the colors of the image.
The algorithm is based on basic k-means clustering with a trick:
Since the first 8 colors of base16 are supposed to be a gradient, before the clustering, it first selects a "base color" and generates a gradient from it by varying its luminance.
Then, the 8 colors of the gradient are passed, together with other 8 randomly initialized colors, as the means to the k-means algorithm.
However, to keep the gradient colors unchanged, they are omitted from the update step -- they still participate in the assignment step so the other colors clusterize around them, but the gradient does not change its values.

It's just a fun experiment I'm doing when I don't have the energy to work on anything else.
Also learning Julia along the way.

## Features

* Creates a palette of 16 colors matching the base16 convention; the output is 16 colors in a `#ddeeff` format.
* Basic k-means algorithm as described above
* Color spaces used when running k-means:
  * RGB (uses HSL internally to scale brightness)
  * Lab
* Visualization:
  * The palette colors
  * The palette colors shown in a 3D plot with the picture's pixels (in a color space that was used for the calculation)

## Improvement ideas

* Better base color selection (e.g., fitting a line through the color space instead of taking a mean)
* Improve the last 8 colors so they do not overlap with the gradient colors
* Better means initialization (e.g., k-means++)
* Select the gradient based on low-frequency components and the last 8 colors based on the high-frequency components. This might lead to the gradient matching more the smooth / background colors while the rest of the color would pick up the details. Maybe?
* CLI options instead of values at the top of the file
* Wrap it in a [Nushell](https://github.com/nushell/nushell) plugin

## Installation

You need to have Julia installed (tested on 1.7).
Then, just run the `Base16.jl`.

The `Release.jl` compiles the project into a [sysimage](https://julialang.github.io/PackageCompiler.jl/dev/sysimages.html) that you can use later to speed up the script startup from outside the Julia REPL.
