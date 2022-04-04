% To use this MATLAB code, you input the adjacency lists of the x-graph and
% y-graph into the function bk_Mixed.  It returns the adjacency list of
% the mixed network, and the bk-mixed for the corresponding edges.
function [subgraph, bkList] = bk_subgraph(subgraph)
if(size(subgraph,2) ~= 2)
    disp('You did not input adjacency lists.')
    disp('Try again.')
    return
end

numberOfNodes = max(subgraph(:));
numberOfEdges = size(subgraph,1);
bkList = zeros(numberOfEdges,1);
graphMatrix = listToMatrix(subgraph,'undirected');

for i = 1:numberOfNodes
    for j = i+1:numberOfNodes
        [cost, route] = dijkstra(graphMatrix,j,i);
        routeList = routeToList(route);
        
        for k = 1:size(routeList,1)
            routeEdge = routeList(k,:);
            index = edgeIndex(subgraph,routeEdge);
            bkList(index) = bkList(index)+cost;
        end
        
    end
end
end

function anEdge = containsEdge(adjacencyList,edge)
    if(find(ismember(adjacencyList,edge,'rows'),1) > 0)
        anEdge = true;
    else
        anEdge = false;
    end
end

function adjacencyMatrix = listToMatrix(adjacencyList, directedOrUndirected)
    directed = false;
    if(strcmp(directedOrUndirected,'directed'))
        directed = true;
    elseif(strcmp(directedOrUndirected,'undirected'))
        directed = false;
    else
        disp('You did not correctly specify if the graph is directed or undirected');
        return
    end

    numberOfNodes = max(adjacencyList(:));
    numberOfEdges = size(adjacencyList,1);
    adjacencyMatrix = zeros(numberOfNodes,numberOfNodes);
    for i = 1:numberOfEdges
        adjacencyMatrix(adjacencyList(i,1),adjacencyList(i,2)) = 1;
        if not(directed)
            adjacencyMatrix(adjacencyList(i,2),adjacencyList(i,1)) = 1;
        end
    end
end

function routeList = routeToList(route)
    routeList = zeros(length(route)-1,2);
    for i = 2:length(route)
        if(route(i-1) < route(i))
            routeList(i-1,1) = route(i-1);
            routeList(i-1,2) = route(i);
        else
            routeList(i-1,1) = route(i);
            routeList(i-1,2) = route(i-1);
        end
    end
end

function index = edgeIndex(edgeList,edge)
    index = find(ismember(edgeList,edge,'rows'));
end