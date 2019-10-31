function Plot6(KF, label)
    load('cT_Setup.mat')
    t  = 10*KF(:,1);
    w  = KF(:,2);
    v  = KF(:,3);
    y  = KF(:,4);
    ye = KF(:,5);
    yv = KF(:,6);
    u  = KF(:,7);   % wr
    ymin = -10*s*0.3084;
    figure
    subplot(2,1,1)
    plot(t,0.3084*u,'k--')
    hold on
    plot(t,0.3084*yv,'r-')
    hold on
    plot(t,0.3084*ye,'k-')
    hold on
   % plot(t,0.3084*u,'k--')
    x  = [300;300];
    yt = [-5; 30];
    plot(x,yt,':k')
    hold on
    x = [420;420];
    plot(x,yt,':k')
    hold on
    axis([0 600 -5 30]);
    title('Sensor-Based State Estimation')
    legend(str31,str32,str33,'Interpreter','latex','Location','southeast')
    xlabel(str21,'Interpreter','latex')
    ylabel(str18,'Interpreter','latex')
    
    subplot(2,1,2)
    plot(t,0.3084*(y-yv),'r-')
    hold on
    plot(t,0.3084*(y-ye),'k-')
    hold on
    x  = [300;300];
    yt = [-5; 5];
    plot(x,yt,':k')
    hold on
    text(300,4.5,str27,'Interpreter','latex');
    hold on
    x = [420;420];
    plot(x,yt,':k')
    hold on
    text(420,4.5,str28,'Interpreter','latex');
    hold on
    title('')
    axis([0 600 -5 5]);
    legend(str34,str35,'Interpreter','latex','Location','southeast')
    xlabel(str21,'Interpreter','latex')
    ylabel(str22,'Interpreter','latex')

    x00=10;
    y00=10;
    width=550;
    height=700;
    set(gcf,'position',[x00,y00,width,height])
    saveas(gcf,label) 
end