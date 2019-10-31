function Plot12(nTrials,label)
    load('cT_Setup.mat')
    global U X
    umax = 0.3048*max(max(U));
    ymin = 0.3048*min(X(1,:))-0.3048*s;
    figure
    subplot(2,1,1)
    for j = 1:nTrials
        plot(Tr,0.3048*U(:,j),'LineWidth',1)
        hold on
    end
    axis([0 60 0 umax])
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')  
    %legend('Vehicle 1','Vehicle 2','Location','southeast')
    title('Driver Simulation')
    
    subplot(2,1,2)  
    for j = 1:nTrials
        plot(Tr,0.3048*X(:,j),'LineWidth',1)
        hold on
    end
    axis([0 60 ymin 1500])
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')  
    title('Driver Simulation')  
    
    x0=10;
    y0=10;
    width=550;
    height=700;
    set(gcf,'position',[x0,y0,width,height])
    saveas(gcf,label) 
end