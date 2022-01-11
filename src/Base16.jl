using Images
using ImageView
using Plots
using Printf
using StatsBase

include("KMeans.jl")
using .KMeans

const MIN_BRIGHTNESS = 0.1
const MAX_BRIGHTNESS = 0.85

function select_base_colors(img)
    nch = size(img)[1]

    if size(img)[1] > 3
        error("Error: Wrong number of channels: ", size(img)[1])
    end

    # Select the base color
    base = reshape(mean(img; dims=(2, 3)), nch)

    # Scale the base color between min and max brightness
    rgb_base = RGB(base[1], base[2], base[3])
    hsl_base = HSL(rgb_base)

    bases = zeros(nch, 8)

    for (i, l) in enumerate(LinRange(MIN_BRIGHTNESS, MAX_BRIGHTNESS, 8))
        res = RGB(HSL(hsl_base.h, hsl_base.s, l))
        bases[1, i] = res.r
        bases[2, i] = res.g
        bases[3, i] = res.b
    end

    return bases
end

function main()
    # img = load("/home/kubouch/pictures/mini/firewatch_4x4.png")
    # img = load("/home/kubouch/pictures/mini/kodim23_crop_24x24a.png")
    img = load("/home/kubouch/pictures/kodim/raw/kodim23.png")
    # img = load("/home/kubouch/pictures/kodim/raw/kodim13.png")
    # img = load("/tmp/wallpaper.jpg")

    # Image types other than RGB do not support math ops => need raw pixels
    inp_img = channelview(img)

    bases = select_base_colors(inp_img);

    means = KMeans.kmeans(inp_img, bases, 8, 10)

    # display(means)
    display(colorview(RGB, means))

    # Plotly backend opens a browser at the end
    plotly()

    # Plot the image pixels
    # Limit max. number of plotted pixels, otherwise it's too slow
    sz = (min(100, size(img)[2]), min(100, size(img)[2]))
    plot_img = channelview(sample(img, sz))

    scatter(
        plot_img[1, :, :],
        plot_img[2, :, :],
        plot_img[3, :, :];
        # Too slow:
        # marker_z=plot_img[3, :, :],
        markersize=0.5,
        markerstrokewidth=0,
        markeralpha=0.5,
        markercolor="black",
        legend=false,
        size=(1000, 1000),
    )

    # Plot the fixed base colors first
    nbases = if ndims(bases) == 1
        size(bases)[1]
    else
        size(bases)[2]
    end

    scatter!(
        means[1, 1:nbases],
        means[2, 1:nbases],
        means[3, 1:nbases];
        # marker_z=means[3, :, :],
        markersize=2,
        # markerstrokewidth=0,
        markercolor="blue",
        legend=false,
        size=(1000, 1000),
    )

    # Plot the rest of the base colors and show the plot
    gui(
        scatter!(
            means[1, nbases+1:end],
            means[2, nbases+1:end],
            means[3, nbases+1:end];
            # marker_z=means[3, :, :],
            markersize=2,
            # markerstrokewidth=0,
            legend=false,
            size=(1000, 1000),
        ),
    )

    # Print out the final colors
    for i in 1:size(means)[2]
        col = means[:, i]

        r = reinterpret(N0f8(col[1]))
        g = reinterpret(N0f8(col[2]))
        b = reinterpret(N0f8(col[3]))

        @printf("#%02x%02x%02x\n", r, g, b)
    end

    return nothing
end

main()
