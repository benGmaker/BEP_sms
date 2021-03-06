function plot3Ddata(N, T, X, do_legend, t_window)
     L = length(T);
     if ~exist('t_window','var')
         % third parameter does not exist, so default it to something
          t_window = T(L);
     end
    figure
    clf

    %plotting x values
    subplot(3,1,1);
    plot(T,X(:,1:N))
    xlim([T(L) - t_window T(L)]) %seting the window
    ylabel('x')
    if do_legend
        legend(arrayfun(@(n)(['x' n]),num2str([1:N]'),'UniformOutput',false))
    end
    %plotting y values
    subplot(3,1,2);
    plot(T,X(:,N+1:2*N))
    xlim([T(L) - t_window T(L)]) 
    ylabel('y')
    if do_legend
        legend(arrayfun(@(n)(['y' n]),num2str([1:N]'),'UniformOutput',false))
    end
    
    %plotting z values
    subplot(3,1,3);
    plot(T,X(:,2*N+1:3*N))
    xlim([T(L) - t_window T(L)]) %seting the window
    ylabel('z')
    xlabel('t [s]')
    if do_legend
        legend(arrayfun(@(n)(['z' n]),num2str([1:N]'),'UniformOutput',false))
    end
    
end