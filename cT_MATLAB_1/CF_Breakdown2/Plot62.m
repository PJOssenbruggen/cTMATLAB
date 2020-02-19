function Plot42(ZZ,ZX,label)
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
    t60 = 0:Ts:60;
    subplot(2,3,1)
    for j = 1:nTrials
        plot(t60,scale*Unew(:,j),'LineWidth',1)
        hold on
    end
    umax = 0.3048*max(max(Unew))*1.05;
    axis([0 60 0 umax])
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')  
    title('Worse Case')
    
    subplot(2,3,4)
    for j = 1:nTrials
        plot(t60,scale*Xnew(:,j))
        hold on
    end 
    ymin = 0.3048*min(Xnew(1,:))-0.3048*s;
    axis([0 60 -750 1500])
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')  
    title('Congestion')
    
    subplot(2,3,2)
    for it = 7:7:size(ZZ,2)
        plot(t,scale*ZZ(:,it))
        hold on
    end
    plot(t,scale*u_mn,'k-','LineWidth',2)
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')
    axis([0 30 -scale*10 scale*100]);
    title('Feedback Control')
    
    subplot(2,3,5)
    for xt = 6:7:size(ZZ,2)
        plot(t,scale*ZZ(:,xt))
        hold on
    end
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')
    axis([0 30 -scale*2500 scale*2500]);
    title('No Congestion')
    
    t      = ZX(:,1);
    x_star = ZX(:,2);
    u_star = ZX(:,3);
    x_m    = ZX(:,4);
    u_m    = ZX(:,5);
    x_f    = ZX(:,6);
    u_f    = ZX(:,7);
    
    subplot(2,3,3)
    for it = 7:7:size(ZX,2)
        plot(t,scale*ZX(:,it))
        hold on
    end
    plot(t,scale*u_mn,'k-','LineWidth',2)
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')
    axis([0 30 -scale*10 scale*100]);
    title('Optimal Control')
    
    subplot(2,3,6)
    for xt = 6:7:size(ZX,2)
        plot(t,scale*ZX(:,xt))
        hold on
    end
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')
    axis([0 30 -scale*2500 scale*2500]);
    title('Maximum Flow')
    
    x00=8;
    y00=10;
    width=700;
    height=500;
    set(gcf,'position',[x00,y00,width,height])
    saveas(gcf,label)  
end

   