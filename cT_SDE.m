% SDE Brownian Motion: Speed 
function cT_SDE(nTrials,X0,Vspeed,sigma)
        load('cT_Setup.mat');
        load('cT_Trial_Table.mat');
        load('cT_Feedback.mat');
        load('cT_U0.mat');
% Create speed, location matrices for the trials.
        U_tk   = 0*ones(n,nTrials);   % speed
    	X_tk   = 0*ones(n,nTrials);   % distance travelled
        S_BM   = 0*ones(n+1,nTrials); % Brownian motion forecasts
% Speed and Location
        for k = 1:nTrials
           for i = 1:n
               BM  = bm(Vspeed(k),sigma(k),'StartTime',0,'StartState',X0(k));
               [S_bm,T] = simulate(BM, n, 'DeltaTime', dt, 'nTrials', 1);
           end 
           S_BM(:,k)   = S_bm;
           dudt        = diff(S_bm)/dt;
           U0          = Trial_Table(k,1);
           dudt(1:100) = Y_cld(1:100,k);
           U_tk(:,k)   = dudt;  
           X_tk(:,k)   = S_bm(1:n);
        end
        
% Location for light traffic
        for k = 1:nTrials
           tmp = 4*X0(k);
           for i = 1:n
               BM  = bm(Vspeed(k),sigma(k),'StartTime',0,'StartState',tmp);
               [S_bm,T] = simulate(BM, n, 'DeltaTime', dt, 'nTrials', 1);
           end  
           S_BM(:,k)   = S_bm;
        end
% Scale transformations: feet to m
    U_tkSI = 0.3048*U_tk;
    S_BMSI = 0.3048*S_BM/1000;
    X_tkSI = 0.3048*X_tk/1000;
    
% Plot
        figure('Name','SDE')
% Estimate speed
        subplot(3,1,1)
        for k = 1:nTrials
           plot(t,U_tkSI(:,k));
           hold on
        end
        axis([0 Tf -0.1 50])
           title('Driver Preferences')
           xlabel(str11,'Interpreter','latex')
           ylabel(str3,'Interpreter','latex')
        
        subplot(3,1,2)
        for k = 1:nTrials
           plot(T,S_BMSI(:,k));
           hold on  
        end
        axis([0 Tf -0.5 2])
           xlabel(str11,'Interpreter','latex')
           ylabel(str2,'Interpreter','latex')
           title('Density Below Capacity')
        
        subplot(3,1,3)
        for k = 1:nTrials         
            plot(t,X_tkSI(:,k));
            hold on 
        end  
        axis([0 Tf -0.2 2])
           xlabel(str11,'Interpreter','latex')
           ylabel(str2,'Interpreter','latex')
           title('Density At Capacity')
    saveas(gcf,'Figure2.pdf')
    save cT_SDE.mat
    save U_tk.mat
    save X_tk.mat
    end
 
