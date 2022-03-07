function M = create_laplacian(N,conn)
    M = zeros(N,N);
    s = size(conn);
    for i = 1:s(1)
        M(conn(i,1),conn(i,2)) = -1;
    end
    M = M + M';
    for i = 1:N
        M(i,i) = -sum(M(i,:));
    end
end