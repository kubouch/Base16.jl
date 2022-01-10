using Images
using ImageView
using Plots

include("KMeans.jl")
using .KMeans

function select_base_colors(img)
    if size(img)[1] > 3
        error("Error: Wrong number of channels: ", size(img)[1])
    end

    base = mean(img; dims=(2, 3))

    return base, base
end

function main()
    img = load("/home/kubouch/pictures/mini/firewatch_4x4.png")
    # img = load("/tmp/wallpaper.jpg")

    # Image types other than RGB do not support math ops => need raw pixels
    inp_img = channelview(img)

    KMeans.kmeans(inp_img, [], 8)

    # Opens a browser
    # plotly()
    # gui(
    #     scatter(
    #         inp_img[1, :, :],
    #         inp_img[2, :, :],
    #         inp_img[3, :, :];
    #         markersize=0.5,
    #         markerstrokewidth=0,
    #         legend=false,
    #         size = (1000, 1000)
    #     ),
    # )

    #base1, base2 = select_base_colors(inp_img);
    # base_lab = Lab(base_lab[1], base_lab[2], base_lab[3])
    # base_rgb = RGB(base_lab)

    return nothing
end

main()
