using BenchmarkTools
using Plots

get_val(r, γ) = (1- r)^(-1/(γ - 1))

n = 1000
Ns = [10, 100, 1000, 10000, 100000, 1000000]
γ = 5/2

N_maxs = Array{Float64,2}(undef, 6, 1000)

for (index, N) in pairs(Ns)
    Ni_results = Array{Float64}(undef, n)
    Threads.@threads for a in 1:n
        Ni_results[a] = maximum(round.((1 .- rand(Float64, N)).^(-1/(γ - 1))))
    end
    N_maxs[index, :]= Ni_results
end

plot([1:1000], N_maxs', layout = (3, 2))

k_max_means = mean(N_maxs, dims=2)

scatter(log10.(Ns), log10.(k_max_means))


