using Statistics
using PyCall
using DelimitedFiles
ndimage = pyimport("scipy.ndimage")

#Q4
function get_max(size, world)
    label_world, nb_labels = ndimage.label(world,[[0,1,0],[1,1,1],[0,1,0]])
    sum = ndimage.sum(world, label_world, index=1:nb_labels)
    return !isempty(sum) ? maximum(sum) / size^2 : 0
end


sizes = [20, 50, 100, 200, 500, 1000]
probs = [i/100 for i = 1:99]
S_avgs = Array{Float64,2}(undef, length(probs), length(sizes))
@time for (i, s) in pairs(sizes)
    @time for j = 1:length(probs)
        worlds = [rand(s, s) .<= probs[j] for i = 1:100]
        S_avgs[j, i] = mean(get_max.(s, worlds))
    end
end
plot(probs, S_avgs, labels=["size = 20" "size = 50" "size = 100" "size = 200" "size = 500" "size = 1000"], legend=:topleft, fmt = png, size=(700,500))
xlabel!("Probability P")
ylabel!("Average Max Fractional Forest Size")
title!("Percolation")
# 0.57 looks to be about correct
savefig(pwd()*"/assignment_8/a8q4g1.png")
