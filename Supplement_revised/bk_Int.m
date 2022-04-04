%This is the main function of the supplement.  It computes the value of 
%b_k^{int} for each edge in the multilayer network.  It takes in the
%adjacency lists for the x- and y-coupled layers and returns the adjacency
%list of the multilayer network as the E x 2 matrix "multilayerList" (where
%E is the number of edges), and the E x 1 vector "bkIntList" that is a 
%list of the corresponding b_k^{int} values for each edge.

function [multilayerList, bkIntList] = bk_Int(x_graph,y_graph)
    if(size(x_graph,2) ~= 2 || size(y_graph,2)~=2)
        disp('You did not input adjacency lists.')
        disp('Try again.')
        return
    end

    multilayerList = [x_graph;y_graph];
    numberOfNodes = max(multilayerList(:));
    numberOfEdges = size(multilayerList,1);
    bkIntList = zeros(numberOfEdges,1);
    mixedGraphMatrix = listToMatrix(multilayerList,'undirected');
    
    for i = 1:numberOfNodes
        for j = i+1:numberOfNodes
            [cost, route] = dijkstra(mixedGraphMatrix,j,i);
            routeList = routeToList(route);
            pathHasXEdge = false;
            pathHasYEdge = false;
            isMixedPath = false;
            for k = 1:size(routeList,1)
                routeEdge = routeList(k,:);
                if(containsEdge(x_graph,routeEdge))
                    pathHasXEdge = true;
                else
                    if(containsEdge(y_graph,routeEdge))
                    pathHasYEdge = true;
                    end
                end
                if(pathHasXEdge && pathHasYEdge)
                    break
                end
            end      
            if(pathHasXEdge && pathHasYEdge)
                isMixedPath = true;
            end
            if(isMixedPath)
                for k = 1:size(routeList,1)
                    routeEdge = routeList(k,:);
                    index = edgeIndex(multilayerList,routeEdge);
                    bkIntList(index) = bkIntList(index)+cost;
                end
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