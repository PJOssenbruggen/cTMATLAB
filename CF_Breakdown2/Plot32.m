function Plot32(label,Tabab)
    load('cT_Setup.mat')
    global U X Unew Xnew
    figure
    umax = 0.3048*max(max(U))*1.05;
    ymin = 0.3048*min(X(1,2))-0.3048*s;
    subplot(2,2,1)
    plot(Tr,0.3048*U(:,1),'-b')
    hold on
    plot(Tr,0.3048*U(:,2),'-k')
    hold on
    axis([0 60 0 umax])
    
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')  
    legend('Lead Vehicle 1','Following Vehicle 2','Location','southeast')
    title('SDE Simulation')
    
    subplot(2,2,3)  
    plot(Tr,0.3048*X(:,1),'-b')
    hold on
    plot(Tr,0.3048*X(:,2),'-k')
    hold on
    axis([0 60 ymin 1500])
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')  
    title('SDE Simulation')

    subplot(2,2,2)
    plot(Tr,0.3048*Unew(:,1),'-b')
    hold on
    plot(Tr,0.3048*Unew(:,2),'-k')
    hold on
    plot(Tabab.Tstart(1),0.3048*Tabab.Ustart(1),'or','MarkerSize',20)
    hold on
    axis([0 60 0 umax])
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex') 
    title('Car-Following')
    
    subplot(2,2,4)   
    plot(Tr,0.3048*Xnew(:,1),'-b')
    hold on
    plot(Tr,0.3048*Xnew(:,2),'-k')
    hold on
    plot(Tabab.Tstart(1),0.3048*Tabab.Xstart(1),'or','MarkerSize',20)
    hold on
    hold on
    axis([0 60 ymin 1500])
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')
    title('Car-Following')
    
    x0=10;
    y0=10;
    width=550;
    height=700;
    set(gcf,'position',[x0,y0,width,height])
    saveas(gcf,label)    
end