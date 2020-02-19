function Plot42(ZZ,label)
    load('cT_Setup.mat')
    global U X Unew Xnew
    t      = ZZ(:,1);
    x_star = ZZ(:,2);
    u_star = ZZ(:,3);
    x_m    = ZZ(:,4);
    u_m    = ZZ(:,5);
    x_f    = ZZ(:,6);
    u_f    = ZZ(:,7);
    s      = s*ones(length(t),1);
    len    = l*ones(length(t),1);
    Sigma  = Sigma*ones(length(t),1);
    scale  = 0.3038;
    Gap    = zeros(length(t),nTrials-1);
    index  = 6:7:size(ZZ,2);
    Dist   = ZZ(:,index);
    ind    = 2:nTrials;
    for i  = 2:nTrials
        Gap(:,i-1) = Dist(:,i-1) - Dist(:,i);
    end
    for i  = 1:nTrials-1
        Gap(:,i) = Gap(:,i) - len;
    end
    %scale  = 1;
    tt     = 7:7:size(ZZ,2);
    u_rw   = ZZ(:,tt);
    u_mn   = 0*ones(size(ZZ,1),1);
    u_sd   = 0*ones(size(ZZ,1),1);
    for i = 1:size(ZZ,1)
        u_mn(i) = mean(u_rw(i,:));
        u_sd(i) = std(u_rw(i,:));
    end
    for i = 1:length(t)
        g_mn(i) = mean(Gap(i,:));
    end
    figure
    subplot(3,1,1)
    for it = 7:7:size(ZZ,2)
        plot(t,scale*ZZ(:,it))
        hold on
    end
    plot(t,scale*u_mn,'k-','LineWidth',2)
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')
    axis([0 30 -scale*10 scale*100]);
    title('Feedback Control')
    
    subplot(3,1,2)
    for xt = 6:7:size(ZZ,2)
        plot(t,scale*ZZ(:,xt))
        hold on
    end
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')
    axis([0 30 -scale*2500 scale*2500]);
    title('Feedback Control')
    
    subplot(3,1,3)
    Gap(:,1) = s-len;
    for i = 2:nTrials-1
        plot(t,scale*Gap(:,i))
        hold on
    end
    plot(t,scale*g_mn,'k-','LineWidth',2)
    hold on
    
    xlabel(str1,'Interpreter','latex')
    ylabel(str26,'Interpreter','latex')
    axis([0 30 0 35]);
    
    x00=10;
    y00=10;
    width=550;
    height=700;
    set(gcf,'position',[x00,y00,width,height])
    saveas(gcf,label)  
end

   