function T = all_metrics(Gm,N,m)
    Am = full(adjacency(Gm)); %Supra adjancy matrix of the multilayer graph
    
    r = size(Gm.Edges); %the total amount of edges including the interlayer
    n_edges = r(1) - N*(m)*(m-1)/2; %computing the number of eges in the layers
    
    %supra matrix metrics
    md = distances(Gm); %node to node distances
    md_avg0 = 1/mean(mean(md)); %initial average distance
    md_dev0 = mean(std(md)); %standard deviation of distances
    mdeg = degree(Gm);
    mdeg_avg0 = mean(mdeg);
    mdeg_std0 = std(mdeg);
    mcen = centrality(Gm,'Pagerank'); %study different kinds of centralities
    mcen_avg0 = mean(mcen);
    mcen_dev0 = std(mcen);
    
    %single layer metrics
    id_avg0 = zeros(1,m); %average distance 
    id_dev0 = zeros(1,m); 
    ideg_avg0 = zeros(1,m);
    ideg_std0 = zeros(1,m);
    icen_avg0 = zeros(1,m);
    icen_dev0 = zeros(1,m);

    for i = 1:m
        Ai =  Am(N*(i-1)+1 : i*N, N*(i-1)+1 : i*N); %grabbing the adjancenty matrix of layer i
        Gi = graph(Ai); %creating a seperate graph

        id = distances(Gi); %node to node distances
        id( isnan( id ) | isinf( id )) = 1e3; %setting non connected nodes to a large distance 
        id_avg0(i) = 1/mean(mean(id)); %initial one over the average distance
        id_dev0(i) = mean(std(id)); %standard deviation of distances
        ideg = degree(Gi); %node degrees
        ideg_avg0(i) = mean(ideg); %average degree
        ideg_std0(i) = std(ideg); %standard deviation of degrees
        icen = centrality(Gi,'Pagerank'); %centrality of nodes
        icen_avg0(i) = mean(icen); %average centrality per layer
        icen_dev0(i) = std(icen); %average standard deviation per layer
    end

    %collapsed layer mertics
    Ac = zeros(N,N);
    for i = 1:m
            Ac = Ac + Am(N*(i-1)+1 : i*N, N*(i-1)+1 : i*N); %adding the i'th adjacency matrix
    end
    
    %computing the nember of 3 and 4 basis cycles
    Gc = graph(Ac); %collapsed graph
    cyc = cyclebasis(Gc);
    n3cyc = 0;
    n4cyc = 0;
    for i = 1:length(cyc)
        p = cell2mat(cyc(i));
        L = length(p);
        if L == 3
            n3cyc = n3cyc + 1;
        elseif L == 4 
            n4cyc = n4cyc + 1;
        end
    end

    %initializing data storage
    varNames = {'Layer','s','t','avg_dist','std_dist','avg_deg','std_deg', 'avg_cen','std_cen', ...
        'L_avg_dist','L_std_dist','L_avg_deg','L_std_deg', 'L_avg_cen','L_std_cen'...
        'n3cyc','n4cyc'};
    l = length(varNames);
    varTypes = cell(1,l);
    varTypes(1:l) = {'double'};

    sz = [n_edges length(varTypes)];
    T = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
    
    %itterating over each possible edge 
    index = 1; %keeping track of the edge index
    for i = 1:m %itterating over the layers
        Ai =  Am(N*(i-1)+1 : i*N, N*(i-1)+1 : i*N); %grabbing the adjancenty matrix of layer i
        Gi = graph(Ai); %creating a seperate graph
        e = Gi.Edges; %edges in layer i
        s_edge = size(e); %size of edges matrix
        for j = 1:s_edge(1) %itterating over edges in the layers
            s = e.EndNodes(j,1); %source node
            t = e.EndNodes(j,2); %target node

            %writing basic data
            T.Layer(index) = i; %adding layer index to data
            T.s(index) = s; %adding source node to data
            T.t(index) = t; %adding target node to data

            Ar = Am; %coppying the orignal matrix to the removed edge matrix
            %removing the edge
            Ar(s + N*(i-1), t + N*(i-1)) = 0; 
            Ar(t + N*(i-1), s + N*(i-1)) = 0;
            Gr = graph(Ar); %generating new graph

            %Supra matrix analysis
            md = distances(Gr); %node to node distances
            T.avg_dist(index) = 1/mean(mean(md)) - md_avg0; %computing mean distance
            T.std_dist(index) = mean(std(md)) - md_dev0;

            mdeg = degree(Gr); %degree
            T.avg_deg(index) = mean(mdeg) - mdeg_avg0;
            T.std_deg(index) = mdeg_avg0 - mdeg_std0;

            mcen = centrality(Gr,'Pagerank'); %centrality
            T.avg_cen(index) = mean(mcen) - mcen_avg0;
            T.std_cen(index) = std(mcen) - mcen_dev0;

            %Single layer analysis
            Gl = graph(Ar(N*(i-1)+1 : i*N, N*(i-1)+1 : i*N)); %graph of the single layer
            L_d = distances(Gl); %node to node distances
            L_d( isnan( L_d ) | isinf( L_d )) = 1e3; %setting non connected nodes to a large distance 
            T.L_avg_dist(index) = 1/mean(mean(L_d)) - id_avg0(i); %computing mean distance
            T.L_std_dist(index) = mean(std(L_d)) - id_dev0(i);

            L_deg = degree(Gl); %degree
            T.L_avg_deg(index) = mean(L_deg) - ideg_avg0(i);
            T.L_std_deg(index) = std(L_deg) - ideg_std0(i);

            L_cen = centrality(Gl,'Pagerank'); %centrality
            T.L_avg_cen(index) = mean(L_cen) - icen_avg0(i);
            T.L_std_cen(index) = std(L_cen) - icen_dev0(i);

            %Collapsed graph analysis
            Ac = zeros(N,N);
            for p = 1:m
                    Ac = Ac + Am(N*(p-1)+1 : p*N, N*(p-1)+1 : p*N); %adding the i'th adjacency matrix
            end
            Gc = graph(Ac); %collapsed graph
            cyc = cyclebasis(Gc); %cycles basis
            %counting the amount of cycles
            r_n3cyc = 0;
            r_n4cyc = 0;
            for p = 1:length(cyc)
                temp = cell2mat(cyc(p));
                L = length(temp);
                if L == 3
                    r_n3cyc = r_n3cyc + 1;
                elseif L == 4 
                    r_n4cyc = r_n4cyc + 1;
                end
            end
            T.n3cyc(index) = r_n3cyc - n3cyc;
            T.n4cyc(index) = r_n4cyc - n4cyc;

            index = index + 1; %increasing the index 
        end  
    end
    

end