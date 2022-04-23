function G = generate_layer(N,n)
    nmax = N*(N-1); %maximum amount of edges
    if n >= nmax
        n = nmax;
    end
    edges = zeros(2,n); %allocating space for edge storrage
    for i = 1:n
        while true
            s = round(rand()*(N-1)+1);
            t = round(rand()*(N-1)+1);
            if s == t
                %checking if it is not self looping
                %disp('removed self loop')
                continue
            end
            if sum(sum(edges == [s; t]) == 2) == 1 || sum(sum(edges == [t; s]) == 2) == 1
                %not checking if this edge already exist
                %disp('removed dupe edge');
                continue
            end
            edges(:,i) = [s;t]; %assigning edge
            break %stopping the while loop
        end
    end
    G = graph(edges(1,:),edges(2,:),[],N);
end
