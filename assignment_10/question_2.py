import numpy as np
import matplotlib.pyplot as plt
import networkx as nx

OBS = 10

probs = list(np.logspace(-4,0,14))

CpList = np.zeros((OBS,14))
LpList = np.zeros((OBS,14))

Gzero = nx.watts_strogatz_graph(1000, 10, 0, seed=None)
C0 = nx.average_clustering(Gzero)
L0 = nx.average_shortest_path_length(Gzero)

for i in range(OBS):
    curC0 = []
    curL0 = []
    for prob in probs:
        G = nx.watts_strogatz_graph(1000, 10, prob, seed=None)
        Cp = nx.average_clustering(G)
        Lp = nx.average_shortest_path_length(G)

        curC0.append(Cp/C0)
        curL0.append(Lp/L0)
    CpList[i, :] = np.asarray(curC0)
    LpList[i, :] = np.asarray(curL0)

CpMeans = np.mean(CpList, axis=0)
LpMeans = np.mean(LpList, axis=0)

plt.scatter(probs, LpMeans)
plt.scatter(probs, CpMeans)
plt.title("Probability by ")
plt.xscale('log')
plt.savefig("assignment_10/a10q2g1.png")
