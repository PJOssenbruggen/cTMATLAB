function cT_CarFollowing(Lead)
% The function deals with a 'lead' and 'following' vehicle only.
    load('U_tk.mat');
    load('X_tk.mat');
    load('Lead.mat');
    Follow = Lead + 1;
% Estimate the following:    
    h_tk   = 3*l*ones(n,1); % headway. Assume a headway of 3*l at t = 0.
    H_tkn  = 0*ones(n,1); % new headway
    H_safe = 0*ones(n,1); % safe headway, two car lengths minimum
    Q_tkn  = 0*ones(n,1); % traffic flow
    n_Viol = 0*ones(n,1); % rule of the road violation
    
% Ideal Conditions. Drivers are unhindered by car-following rules %%%%%%%%%%%
% X_tk and U_tk matrices are known
% Estimate safe headway spaces: H_safe
    for i = 1:n
        speed     = U_tk(i,Lead);
        H_safe(i) = cT_SafeHeadway(speed,l);
        h_tk(i)   = X_tk(i,Lead) - X_tk(i,Follow);
    end
 
% Drivers are hindered by car-following rules  
% If a following vehicle violates the safe headway rule (distance), then it 
% must slow down. It is assumed that the vehicle will to the lead vehicle speed. 
% Fix following vehicle speed U_tk(i,Follow) and X_tk(i,Follow)
% if there is a safe headway violation.
     for i = 2:n
         if h_tk(i) < H_safe(i); % following vehicle violates safe driving rule
            U_tk(i,Follow)  = U_tk(i,Lead);
            n_Viol(i)       = 1;
            u_lead          = U_tk(i,Lead);
            h_safe1         = cT_SafeHeadway(u_lead,l);
            x_follow1       = X_tk(i,Lead) - h_safe1; 
            x_follow2       = X_tk(i-1,Lead) + dt*U_tk(i,Follow);
            X_tk(i,Follow)  = min(x_follow1, x_follow2);
            h_safe2         = dt*U_tk(i,Follow);
            h_tk(i)         = max(h_safe1, h_safe2);
         end
     end 
    U_t(:,Lead)   = U_tk(:,Lead);
    X_t(:,Lead)   = X_tk(:,Lead);
    U_t(:,Follow) = U_tk(:,Follow);
    X_t(:,Follow) = X_tk(:,Follow);
    V_t(:,Lead)   = n_Viol;
% Calculate flow  q = k * u
    H_ft        = mean(h_tk(100:n));
    U_fpsLead   = mean(U_tk(100:n,Lead));
    U_fpsFollow = mean(U_tk(100:n,Follow));
    n_Viol      = sum(n_Viol);
    T = table(Lead,n_Viol,H_ft,U_fpsLead,U_fpsFollow)
% Scale transformations: feet to m
    U_tkSI = 0.3048*U_tk;
    X_tkSI = 0.3048*X_tk/1000;
    h_tkSI = 0.3048*h_tk;
    
% Plots     
    figure('Name','CarFollowing')
    subplot(3,1,1)
    plot(t,U_tkSI(:,Lead),'k-')
    hold on
    plot(t,U_tkSI(:,Follow),'r-')
    hold on
    title(['Vehicles ',num2str(Lead),' and ',num2str(Follow),''])
    axis([0 Tf -0.1 60])
    ylabel(str3,'Interpreter','latex')
    xlabel(str11,'Interpreter','latex') 
    legend('Lead u_L','Following u_F','Location','northwest') 
    hold off

    subplot(3,1,2)
    plot(t,h_tkSI,'k-')
    hold on
    title(['Vehicles ',num2str(Lead),' and ',num2str(Follow),''])
    hmax = 1.5*max(h_tkSI);
    axis([0 Tf -0.1 hmax])
    ylabel(str4,'Interpreter','latex')
    xlabel(str11,'Interpreter','latex') 
    hold off
    
    subplot(3,1,3)
    plot(t,X_tkSI(:,Lead),'k-')
    hold on
    plot(t,X_tkSI(:,Follow),'r-')
    hold on
    title(['Vehicles ',num2str(Lead),' and ',num2str(Follow),''])
    axis([0 Tf -0.5 2])
    ylabel(str2,'Interpreter','latex')
    xlabel(str11,'Interpreter','latex') 
    legend('Lead x_L','Following x_F','Location','southeast') 
    hold off
    
    if Lead == 2 
        saveas(gcf,'Figure3.pdf')  
    end
    H_tk(:,Lead) = h_tk(:); 
    save U_tk.mat
    save X_tk.mat
    save H_tk.mat
    Lead = Follow;
    save Lead.mat
end