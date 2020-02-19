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
    x = [10;10];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    x = [30;30];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    x = [42;42];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    axis([0 60 -3 umax])
    x = [0;60];
    y = [0;0];
    plot(x,y,'-k')
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')  
    title('Side-by-Side: Left-lane')
    
    subplot(2,2,3)  
    Z = [Tr X];
    for j = 1:nTrials
        plot(Tr,0.3048*X(:,j),'LineWidth',1)
        hold on
    end
    x = [10;10];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    x = [30;30];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    x = [42;42];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    text(10,1400,str36,'Interpreter','latex');
    hold on
    text(30,1400,str27,'Interpreter','latex');
    hold on
    text(42,1400,str28,'Interpreter','latex');
    hold on
    axis([0 60 ymin 1500])
    x = [0;60];
    y = [0;0];
    plot(x,y,'-k')
    hold on
    y = [Z(101,2)*0.3084;Z(101,2)*0.3084;];
    plot(x,y,':k')
    hold on
    y = y(1) + 50;
    text(3,y,str39,'Interpreter','latex');
    y = [Z(301,2)*0.3084;Z(301,2)*0.3084;];
    plot(x,y,':k')
    hold on
    y = y(1) + 50;
    text(3,y,str40,'Interpreter','latex');
    hold on;
    y = [Z(421,2)*0.3084;Z(421,2)*0.3084;];
    plot(x,y,':k')
    y = y(1) + 50;
    hold on
    text(3,y,str41,'Interpreter','latex');
    hold on;
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')  
    title('Safe Merge')
    

    subplot(2,2,2)
    for j = 1:nTrials
        plot(Tr,0.3048*Unew(:,j),'LineWidth',1)
        hold on
    end
    x = [10;10];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    x = [30;30];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    x = [42;42];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    axis([0 60 -3 umax])
    x = [0;60];
    y = [0;0];
    plot(x,y,'-k')
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex') 
    title('Side-by-Side: Right-lane')
    
    subplot(2,2,4)  
    Z = [Tr X];
    for j = 1:nTrials
        plot(Tr,0.3048*Xnew(:,j),'LineWidth',1)
        hold on
    end
    x = [10;10];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    x = [30;30];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    x = [42;42];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
    text(10,1400,str36,'Interpreter','latex');
    hold on
    text(30,1400,str27,'Interpreter','latex');
    hold on
    text(42,1400,str28,'Interpreter','latex');
    hold on
    axis([0 60 ymin 1500])
    hold on
    axis([0 60 ymin 1500])
    x = [0;60];
    y = [0;0];
    plot(x,y,'-k')
    hold on
    y = [Z(101,2)*0.3084;Z(101,2)*0.3084;];
    plot(x,y,':k')
    hold on
    y = y(1) + 50;
    text(3,y,str39,'Interpreter','latex');
    y = [Z(301,2)*0.3084;Z(301,2)*0.3084;];
    plot(x,y,':k')
    hold on
    y = y(1) + 50;
    text(3,y,str40,'Interpreter','latex');
    hold on;
    y = [Z(421,2)*0.3084;Z(421,2)*0.3084;];
    plot(x,y,':k')
    y = y(1) + 50;
    hold on
    text(3,y,str41,'Interpreter','latex');
    hold on;

    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')  
    title('Safe Merge')
    
    x0=10;
    y0=10;
    width=550;
    height=700;
    set(gcf,'position',[x0,y0,width,height])
    saveas(gcf,label)    
end