using Statistics
using PyCall
using DelimitedFiles
using StatsPlots
ndimage = pyimport("scipy.ndimage")

# Q5
pc = 0.57
N = 1000
ps = [pc, pc/2, pc + (1-pc)/2]
sizes = Dict()
@time for p in ps
    world = rand(500, 500) .<= p
    label_world, nb_labels = ndimage.label(world,[[0,1,0],[1,1,1],[0,1,0]])
    sizes[p] = ndimage.sum(world, label_world, 1:nb_labels)
end

density(sizes[pc])
xlabel!("Forest Sizes for (500,500)")
title!("Pc")
savefig(pwd()*"/assignment_8/a8q5g1.png")
density(sizes[pc/2])
xlabel!("Forest Sizes for (500,500)")
title!("Pc/2")
savefig(pwd()*"/assignment_8/a8q5g2.png")
density(sizes[pc + (1-pc)/2])
xlabel!("Forest Sizes for (500,500)")
title!("Pc + (1-Pc)/2")
savefig(pwd()*"/assignment_8/a8q5g3.png")
