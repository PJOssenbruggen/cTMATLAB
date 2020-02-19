function Plot4(U, X, newTrials,label, Performance)
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
    t1 = 0:Ts:Tr(301);
    t2 = Tr(302):Ts:Tr(421);
    t3 = Tr(422):Ts:Tr(601);
    U_301 = U(301,:)';
    U_421 = U(421,:)';
    X_301 = X(301,:)';
    X_421 = X(421,:)'; 
    t301  = 30*ones(newTrials,1);
    t421  = 42*ones(newTrials,1);
    % Start Up
    figure
    subplot(2,1,1)
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
    axis([0 60 -3 umax])
    x = [0;60];
    y = [0;0];
    plot(x,y,'-k')
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')  
    %legend('Vehicle 1','Vehicle 2','Location','southeast')
    title('Side-by-Side Merge') 
    
    subplot(2,1,2)  
    Z = [Tr X];
    for j = 1:newTrials
        plot(Tr,0.3084*X(:,j),'LineWidth',1)
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
    title('Safe, Delayed Traffic') 
    
    
    x0=10;
    y0=10;
    width=550;
    height=700;
    set(gcf,'position',[x0,y0,width,height])
    saveas(gcf,label) 
end