module KMeans

using StatsBase

function initialize(colors, fixed, n)
    y = sample(1:size(colors)[2], n)
    x = sample(1:size(colors)[3], n)

    means = zeros(size(colors)[1], n)

    for i in 1:n
        means[:, i] = colors[:, y[i], x[i]]
    end

    return means
end

function assign_clusters!(colors, means, clusters)
    nmeans = size(means)[2]

    distances = zeros((nmeans, size(colors)[2], size(colors)[3]))

    for i in 1:nmeans
        mean = means[:, i]

        distances[i, :, :] = sqrt.(sum((colors .- mean) .^ 2; dims=1))
    end

    clusters[:] = first.(Tuple.(argmin(distances; dims=1)))
end

function update_means(colors, means, clusters) end

function kmeans(colors, fixed, n)
    means = initialize(colors, fixed, n)

    # Holds a cluster index per each color
    clusters = zeros(Int, size(colors)[2], size(colors)[3])

    assign_clusters!(colors, means, clusters)
    display(clusters)
    display(means)

    return means
end

end  # module
