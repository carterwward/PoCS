using PyCall
using Random
using StatsBase
using Plots

plt = pyimport("matplotlib.pyplot")
display = pyimport("IPython.display")
ndimage = pyimport("scipy.ndimage")

get_site_prob(i, j, l) = ℯ^(-i/l)*ℯ^(-j/l)

function get_probs(L)
    probs = Array{Float64,2}(undef, L, L)
    l = L/10
    for i=1:L
        for j=1:L
            probs[i,j] = get_site_prob(i,j, l)
        end
    end
    return probs ./ sum(probs)
end

function calc_avg_trees_burned(probs::Array{Float64,2}, world::Array{Int,2}, L::Int)
    label_world, nb_labels = ndimage.label(world,[[0,1,0],[1,1,1],[0,1,0]])
    avg = 0
    for i=1:L
        for j=1:L
            if world[i,j] == 0
                continue
            end
            avg += probs[i,j]*sum(label_world.==label_world[i,j])
        end
    end
    return avg
end

function calc_avg_yield(world::Array{Int, 2}, probs::Array{Float64,2}, L::Int)
    num_sites = length(world)
    num_trees = sum(world)
    avg_trees_burned = calc_avg_trees_burned(probs, world, L)
    return num_trees/num_sites - avg_trees_burned/num_sites
end

function choose_tree(d::Int64, world::Array{Int}, probs::Array{Float64,2}, L::Int)
    avg_yields = Vector{Float64}()
    open_spots = findall(x -> x==0, world)
    shuffle!(open_spots)
    used_spots = Vector{eltype(open_spots)}()

    for i=1:d
        if isempty(open_spots)
            continue
        end
        copy_world = deepcopy(world)
        site = pop!(open_spots)
        copy_world[site] = 1
        avg_yield = calc_avg_yield(copy_world, probs, L)

        push!(avg_yields, avg_yield)
        push!(used_spots, site)
    end
    max_yield, max_avg_yield_indx = findmax(avg_yields)
    world[used_spots[max_avg_yield_indx]] = 1

    return max_yield, deepcopy(world)
end

function draw_world(world::Array{Int,2})
    plt.cla()
    plt.imshow(world, cmap="cool")
end

function main()
    # L values
    L = 64
    D = [1, 2, L, L^2]
    max_matrices = []
    avg_yields_mat = Array{Float64}(undef, length(D),L^2)
    max_yields = []

    probs = get_probs(L)

    @time for (i, d) in pairs(D)
        # Create world
        world = zeros(Int, L,L)
        max_matrix = nothing
        avg_yields = Vector{Float64}()
        max_yield = 0
        while zero(eltype(world)) in world
            avg_yield, sample_world = choose_tree(d, world, probs, L)
            if avg_yield > max_yield
                max_yield = avg_yield
                max_matrix = deepcopy(sample_world)
            end
            push!(avg_yields, avg_yield)
        end
        push!(max_matrices, max_matrix)
        push!(max_yields, max_yield)
        avg_yields_mat[i, :] = avg_yields

        folder = pwd()*"/assignment_9/L_"*string(L)*"_d_"*string(d)

        if !isdir(folder)
            mkdir(folder)
        end

        fig, ax = plt.subplots(figsize=(10, 10))
        ax.set_ylim(0,L)
        ax.set_xlim(0,L)
        ax.set_aspect("equal")

        draw_world(max_matrix)
        plt.title("D="*string(d)*" L="*string(L), fontsize=20)
        plt.savefig(folder*"/max_yield.png")
        plt.clf()

        println("D= ", d, " max yield is ", max_yield)
    end

    densities = [i/L^2 for i=1:L^2]

    plot(densities, avg_yields_mat', labels=reshape("D=".*string.(D), 1, :), legend=:topleft, fmt = png, size=(700,500))
    title!("Yield Density Curves")
    xlabel!("Density")
    ylabel!("Yield")
    savefig(pwd()*"/assignment_9"*"/64_density_yield_curve.png")

    for (m, max_matrix) in pairs(max_matrices)
        forest_sizes = []
        label_world, nb_labels = ndimage.label(max_matrix,[[0,1,0],[1,1,1],[0,1,0]])
        for s = 1:nb_labels
            push!(forest_sizes, sum(label_world.==s))
        end
        sort!(forest_sizes, rev=true)
        scatter(1:length(forest_sizes), log10.(forest_sizes), fmt = png, size=(700,500), legend=nothing)
        title!("Zipf Forest Size Distribution")
        xlabel!("log10 of Rank")
        ylabel!("log10 of Forest Size")
        savefig(pwd()*"/assignment_9/"*"d_"*string(D[m])*"_64_zipf.png")

    end
end

main()