function Plot2(nTrials,U,X,Unew,Xnew,label)
    load('cT_Setup.mat')
    figure
    umax = 0.3048*max(max(U))*1.05;
    umax1= 0.3048*max(max(Unew))*1.05;
    umax = max([umax umax1])
    ymin = 0.3048*min(X(1,:))-0.3048*s;
    subplot(2,2,1)
    % Tr time
    for j = 1:nTrials
        plot(Tr,0.3048*U(:,j),'LineWidth',1)
        hold on
    end
    x = [30;30];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    x = [42;42];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    axis([0 60 0 umax])
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')  
    title('Left-lane')
    
    subplot(2,2,3)  
    for j = 1:nTrials
        plot(Tr,0.3048*X(:,j),'LineWidth',1)
        hold on
    end
    x = [30;30];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    x = [42;42];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    text(30,1400,str27,'Interpreter','latex');
    hold on
    text(42,1400,str28,'Interpreter','latex');
    hold on
    axis([0 60 ymin 1500])
    hold on
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')  
    

    subplot(2,2,2)
    for j = 1:nTrials
        plot(Tr,0.3048*Unew(:,j),'LineWidth',1)
        hold on
    end
    x = [30;30];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    x = [42;42];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    axis([0 60 0 umax])
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex') 
    title('Right-lane')
    
    subplot(2,2,4)   
    for j = 1:nTrials
        plot(Tr,0.3048*Xnew(:,j),'LineWidth',1)
        hold on
    end
    x = [30;30];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    x = [42;42];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    text(30,1400,str27,'Interpreter','latex');
    hold on
    text(42,1400,str28,'Interpreter','latex');
    hold on
    axis([0 60 ymin 1500])
    hold on
    axis([0 60 ymin 1500])
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')  
    
    
    x0=10;
    y0=10;
    width=550;
    height=700;
    set(gcf,'position',[x0,y0,width,height])
    saveas(gcf,label)    
end