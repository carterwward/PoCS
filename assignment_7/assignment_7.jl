get_val(r, γ) = (1- r)^(-1/(γ - 1))

n = 1000
N = 1000000
Ns = [10, 100, 1000, 10000, 100000, 1000000]
γ = 5/2

Ni_dict = Dict(i => Array{Float64,2}(undef, n, i) for i in Ns)
# Ni_dict = Dict()

# for key in keys(Ni_dict)
#     println(size(Ni_dict[key]))
# end
N_maxs = Array{Float64,2}(undef, 6, 1000)
@benchmark for N in Ns
    # results = [[] for _ in 1:Threads.nthreads()];
    # Threads.@threads for a in 1:n
    for a in 1:n
        for b in 1:N
            # results[Threads.threadid()] = round(get_val(np.random.uniform(), gamma))
            Ni_dict[N][a,b] = round(get_val(rand(), γ))
        end
    end
end
do_plot(k) = plot(scatter(x=x_ax, y=Ni_dict[k]))
p = [do_plot(10) do_plot(100) do_plot(1000) do_plot(100000) do_plot(1000000)]
for (key, value) in Ni_dict
    vals, inds = findmax(value, dims=2)
    x_ax = [i for i in 1:1000]
    p_i = plot(scatter(x=x_ax, y=vals))
    # p_i
    append!(p, p_i)
end
PlotlyJS.relayout!(p)
p


