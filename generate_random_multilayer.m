function G = generate_random_multilayer (N,n,m)
%N number of nodes in each layer
%n number of edges in each layer
%m number of layers

d = diag(ones(N,1)); %diagonal matrix
sA = kron(ones(m,m)-diag(ones(m,1)),d); %supra matrix of A 
for i = 1:m
    L = generate_layer(N,n); %generating a random layer
    A = full(adjacency(L)); %generating the adjacency matrix
    sA(N*(i-1)+1 : i*N, N*(i-1)+1 : i*N) = A; %placing layer connection on the diagonal
end

layernames = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}; %Letters of each node
nodenames = cell(1,N*m);

%creating the node names
for i = 1:m
    for j = 1:N
        nodenames((i-1)*(N)+j) = {[cell2mat(layernames(i)) int2str(j)]};
    end
end

G = graph(sA,nodenames); %generating the graph