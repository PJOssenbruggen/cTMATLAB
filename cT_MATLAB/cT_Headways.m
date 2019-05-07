function cT_Headways
    load('cT_Setup.mat');
    load('U_tk.mat');
    load('H_tk.mat');
    K_tk   = 0*ones(n,nTrials-1); % density
    q_mn   = 0*ones(n,1);         % flow
%   Speed, density, flow
    u_mph = mean(U_tk')*3600/5280;
    u_sd  = std(U_tk')*3600/5280;
    h_ft  = mean(H_tk');
    h_sd  = std(H_tk');
 % Estimate Trafic Density
    for k = 1:nTrials-1
        for i = 2:n
        k1 = 5280/H_tk(i,k); 
        K_tk(i,k) = k1; 
        end
    end
% Estimate Trafic flow
    k_vpm = mean(K_tk');
    for i = 1:n
        q_mn(i) = k_vpm(i) * u_mph(i); 
        end
    q = u_mph/h_ft*5280;
% Fit ARIMA models
    ukq    = [u_mph; k_vpm; q_mn']';
    ukq_mn = mean(ukq(101:601,:))
    s1 = ukq(101:601,1);
    s2 = ukq(101:601,2);
    s3 = ukq(101:601,3);
    ds2 = diff(ukq(101:601,2));
    ds3 = diff(ukq(101:601,3));
    figure('Name','Autocorr')
    mdl = arima(1,1,1);
    cT_Arima(s2,mdl)
    mdl = arima(1,1,1);
    cT_Arima(s3,mdl)
   
    

    figure('Name','Headways')
    subplot(3,1,1)
    plot(t,u_mph,'k-');
    xlabel(str11,'Interpreter','latex') 
    ylabel(str9,'Interpreter','latex')
    title('Performance')
 %   legend('Vehicles 1 and 2','Vehicles 2 and 3','Vehicles 3 and 4','Location','southwest')
        
    subplot(3,1,2)
    plot(t,k_vpm,'k-');
    xlabel(str11,'Interpreter','latex') 
    ylabel(str10,'Interpreter','latex')
    title('')
 %   legend('Vehicles 1 and 2','Vehicles 2 and 3','Vehicles 3 and 4','Location','northwest')
    
    subplot(3,1,3)
    plot(t,q_mn,'k-');
    xlabel(str11,'Interpreter','latex') 
    ylabel(str6,'Interpreter','latex')
    title('')
 %   legend('Vehicles 1 and 2','Vehicles 2 and 3','Vehicles 3 and 4','Location','northwest')
    saveas(gcf,'Figure4.pdf')  
end