function Plot42(Z,label)
    load('cT_Setup.mat')
    global U X Unew Xnew
    t      = Z(:,1);
    x_star = Z(:,2);
    u_star = Z(:,3);
    x_m    = Z(:,4);
    u_m    = Z(:,5);
    x_f    = Z(:,6);
    u_f    = Z(:,7);
    s      = s*ones(length(t),1);
    Sigma  = Sigma*ones(length(t),1);
    scale  = 0.3038;
    %scale  = 1;
    
    figure
    subplot(2,2,1)
    plot(t,scale*u_m,'b-','LineWidth',1)
    hold on
    plot(t,scale*u_f,'k-','LineWidth',1)
    hold on
    plot(t,scale*u_star,'r--','LineWidth',1)
    axis([0 30 0 scale*100]);
    title('Speed')
    legend('u(t)','u_f(t)','u^*(t)','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')

    subplot(2,2,2)
    plot(t,scale*x_m,'b-','LineWidth',1)
    hold on
    plot(t,scale*x_f,'k-','LineWidth',1)
    hold on
    plot(t,scale*x_star,'r--','LineWidth',1)
   % axis([0 30 -s(1)*scale 1.1*scale*max(x_star)]);
    title('Location')
    legend('x(t)','x_f(t)','x^*(t)','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')
    
    subplot(2,2,3)
    plot(t,scale*(u_m-u_star),'b-','LineWidth',1)
    hold on
    plot(t,scale*(u_f-u_star),'k-','LineWidth',1)
    hold on
    plot(t,scale*Sigma,'r--');
    hold on
    plot(t,-scale*Sigma,'r--');
    title('Error')
    legend('u(t) - u^*(t)','u_f(t) - u^*(t)','\pm\sigma','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')
    axis([0 30 -8*Sigma(1)*scale 8*Sigma(1)*scale]);
    
    subplot(2,2,4)
    plot(t,scale*(x_m-x_star),'b-','LineWidth',1)
    hold on
    plot(t,scale*(x_f-x_star),'k-','LineWidth',1)
    hold on
    plot(t,Ts*scale*s,'r--');
    hold on
    plot(t,-Ts*scale*s,'r--');
    title('Error')
    legend('x(t) - x^*(t)','x_f(t) - x^*(t)','\pm\Deltat\sigma','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')
    axis([0 30 -1.2*Ts*s(1)*scale 1.2*Ts*s(1)*scale]);

    x00=10;
    y00=10;
    width=550;
    height=700;
    set(gcf,'position',[x00,y00,width,height])
    saveas(gcf,label)  
end