%This is a test of the bk_Mixed code using the 6-node network we have been
%using, with x everywhere but edge 5-6, which is a y edge.

xGraph = csvread('xGraph.csv');
yGraph = csvread('yGraph.csv');

[x_subgraph, b_x] = bk_subgraph(xGraph);
[y_subgraph, b_y] = bk_subgraph(yGraph);
