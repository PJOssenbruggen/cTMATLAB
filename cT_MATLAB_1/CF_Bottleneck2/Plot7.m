function Plot7(newTrials,U, X, Unew, Xnew, label)
    load('cT_Setup.mat')
    umax = 0.3048*max(U)*1.1;           % umax and ymin used for axes.
    umax = max(umax);
    ymin = 0.3048*min(X)-0.3048*s;
    ymin = min(ymin);
    % Time intervals: 0 < t < 30 seconds for vehicles in left and right
    % lanes traveling independently. No lane changing or passing.
    %U = [U1(1:n1-1,:); U2(1:n2-1,:); U3(1:n3,:)];
    %X = [X1(1:n1-1,:); X2(1:n2-1,:); X3(1:n3,:)];
    % Phase 1:  0 < t < 30 seconds
    % Phase 2: 30 < t < 42 seconds
    % Phase 3: 42 < t < 60 seconds
    t1    = 0:Ts:Tr(301);
    t2    = Tr(302):Ts:Tr(421);
    t3    = Tr(422):Ts:Tr(601);
    U_301 = U(301,:)';
    U_421 = U(421,:)';
    X_301 = X(301,:)';
    X_421 = X(421,:)'; 
    t301  = 30*ones(newTrials,1);
    t421  = 42*ones(newTrials,1);
    % Start Up
    figure
    subplot(2,2,1)
    for j = 1:newTrials
        plot(Tr,0.3084*U(:,j),'LineWidth',1)
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
    axis([0 60 0 umax])
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')  
    title('Left-lane')
    
    subplot(2,2,3)  
    for j = 1:newTrials
        plot(Tr,0.3084*X(:,j),'LineWidth',1)
        hold on
    end
    x = [10;10];
    y = [ymin; 1500];
    plot(x,y,':k')
        hold on
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
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')  
    title('') 
    
    subplot(2,2,2)
    for j = 1:newTrials
        plot(Tr,0.3084*Unew(:,j),'LineWidth',1)
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
    
    axis([0 60 ymin 1500])
    hold on
    axis([0 60 0 umax])
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')  
    %legend('Vehicle 1','Vehicle 2','Location','southeast')
    title('Right-lane') 
    
    subplot(2,2,4)  
    for j = 1:newTrials
        plot(Tr,0.3084*Xnew(:,j),'LineWidth',1)
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
    axis([0 60 ymin 1500])
    text(10,1400,str36,'Interpreter','latex');
    hold on
    text(30,1400,str27,'Interpreter','latex');
    hold on
    text(42,1400,str28,'Interpreter','latex');
    hold on
    axis([0 60 ymin 1500])
    hold on
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')  
    title('') 
    
    x0=10;
    y0=10;
    width=550;
    height=700;
    set(gcf,'position',[x0,y0,width,height])
    saveas(gcf,label) 
end