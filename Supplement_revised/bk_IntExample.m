%This code produces the values of b_k^{int} for each edge in the network 
%presented in Fig. 4b after edge 3-5 has been replaced.  This example 
%outputs the edge list for the network (independent of the layer of the
%edge in the variable "edgeList," and the list of b_k^{int} values
%corresponding to each edge in "bkList."

%These lines are where the code loads the edge lists for the x layer and y
%layer.  To adapt this code, simply replace xGraph.csv and yGraph.csv with
%your respective x and y graph edge lists.
xGraph = csvread('xGraph.csv');
yGraph = csvread('yGraph.csv');

[edgeList, bkList] = bk_Int(xGraph,yGraph);
disp(['Source ' 'Target ' 'b_k^{int}']) 
disp([edgeList bkList])

