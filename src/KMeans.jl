module KMeans

using StatsBase

function initialize(colors, fixed, n)
    y = sample(1:size(colors)[2], n)
    x = sample(1:size(colors)[3], n)

    means = zeros(size(colors)[1], n)

    for i in 1:n
        means[:, i] = colors[:, y[i], x[i]]
    end

    return [fixed means]
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

function update_means!(colors, means, clusters, nfixed)
    nmeans = size(means)[2]

    for i in nfixed+1:nmeans
        mask = clusters .== i
        cluster = colors[:, mask]
        if size(cluster)[2] > 0
            means[:, i] = mean(cluster, dims=2)
        end
    end
end

function kmeans(colors, fixed, nmeans, nsteps)
    # Number of fixed means that do not get updated
    nfixed = if ndims(fixed) == 1
        size(fixed)[1]
    else
        size(fixed)[2]
    end
    means = initialize(colors, fixed, nmeans)

    # Holds a cluster index per each color
    clusters = zeros(Int, size(colors)[2], size(colors)[3])

    for _ in 1:nsteps
        assign_clusters!(colors, means, clusters)
        update_means!(colors, means, clusters, nfixed)
    end

    return means
end

end  # module
