using BenchmarkTools
using Plots
using Statistics
using PyCall
py_stats = pyimport("scipy.stats")

n = 1000
Ns = [10, 100, 1000, 10000, 100000, 1000000]
γ = 3/2

N_maxs = Array{Float64,2}(undef, 6, 1000)

@time for (index, N) in pairs(Ns)
    Ni_results = Array{Float64}(undef, n)
    Threads.@threads for a in 1:n
        Ni_results[a] = maximum(round.((1 .- rand(Float64, N)).^(-1/(γ - 1))))
    end
    N_maxs[index, :]= Ni_results
end

plot([1:1000], N_maxs', layout = (2, 3), labels=["size = 10" "size = 100" "size = 1000" "size = 10000" "size = 100000" "size = 1000000"], size=(800,600), fmt = :png)
xlabel!("Sample")
ylabel!("K Max")

savefig(pwd()*"/assignment_8/a8q1g1.png")

#b
k_max_means = mean(N_maxs, dims=2)
x = log10.(Ns)
y = log10.(k_max_means)[:, 1]

regr = py_stats.linregress(x, y)

scatter(log10.(Ns), log10.(k_max_means), labels="observed means", legend=:topleft, size=(800,500), fmt=:png)
plot!(log10.(Ns) .* regr[1] .+ regr[2], labels="β = "*string(regr[1]), legend=:topleft)
xlabel!("log10 of N")
ylabel!("log10 of mean k maxs")
savefig(pwd()*"/assignment_8/a8q1g2.png")