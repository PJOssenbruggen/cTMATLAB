function cT_Headways(K_t)
    load('cT_Setup.mat');
    
    figure('Name','Headways')
    plot(t,K_t);
    %axis([0 60 -50 100]);
    xlabel(str1,'Interpreter','latex') 
    ylabel(str8,'Interpreter','latex')
    title('Congestion Impacts')
    legend('Vehicles 1 and 2','Vehicles 2 and 3','Vehicles 3 and 4','Location','southwest')
    saveas(gcf,'Figure4.pdf')  
end