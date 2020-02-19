function Plot5(D1,D2,label)
    load('cT_Setup.mat')
    t      = 0:Ts:Tf;     % time
    U1     = D1(:,1:10);  % speed
    X1     = D1(:,11:20); % LQR
    U2     = D2(:,1:10);  % speed
    X2     = D2(:,11:20); % LQR
    umax1  = 0.3048*max(U1(:,1))*1.1; 
    umax2  = 0.3048*max(U2(:,1))*1.1; 
    umax   = max(umax1,umax2)*1.1;
    ymin   = -10*s*0.3084;
    
    figure
    subplot(2,1,1)
    plot(t,0.3048*U1)
    hold on
    plot(t,0.3048*U2)
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
    plot(x,y,':k')
    hold on
    axis([0 60 -3 umax]);
    x = [0;60];
    y = [0;0];
    plot(x,y,'-k')
    title('Driver Assisted Side-by-Side Merge')
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')

    subplot(2,1,2)
    t = t';
    Z = [t X1];
    plot(t,0.3048*X1)
    hold on
    plot(t,0.3048*X2)
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
    axis([0 60 ymin 1500]);
    x = [0;60];
    y = [0;0];
    plot(x,y,'-k')
    hold on
    text(10,1400,str36,'Interpreter','latex');
    hold on
    text(30,1400,str27,'Interpreter','latex');
    hold on
    text(42,1400,str28,'Interpreter','latex');
    hold on
    axis([0 60 ymin 1500])
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
    title('Minimum Delay')
   
    x00=10;
    y00=10;
    width=550;
    height=700;
    set(gcf,'position',[x00,y00,width,height])
    saveas(gcf,label) 
end
