% SDE Brownian Motion: Speed 
function cT_SDE(nTrials,X0,Vspeed,sigma)
        load('cT_Setup.mat');
        load('cT_Trial_Table.mat');
        load('cT_Feedback.mat');
        load('cT_U0.mat');
% Create speed, location matrices for the trials.
        U_tk   = 0*ones(n,nTrials); % speed
    	X_tk   = 0*ones(n,nTrials); % distance travelled
% Plot
        figure('Name','SDE')
% Estimate speed
        subplot(3,1,1)
        for k = 1:nTrials
           tmp = 4*X0(k);
           for i = 1:n
               BM  = bm(Vspeed(k),sigma(k),'StartTime',0,'StartState',tmp);
               [S_BM,T] = simulate(BM, n, 'DeltaTime', dt, 'nTrials', 1);
           end 
           u_BM  = diff(S_BM)/dt;
           dudt  = diff(S_BM)/dt;
           U0    = Trial_Table(k,1);
           dudt(1:100) = Y_cld(1:100,k);
           u_BM        = dudt;
           plot(t,u_BM)
           hold on
           title('Driver Preferences')
           xlabel(str1,'Interpreter','latex')
           ylabel(str3,'Interpreter','latex')
        end
        
        subplot(3,1,2)
        for k = 1:nTrials
           tmp = 4*X0(k);
           for i = 1:n
               BM  = bm(Vspeed(k),sigma(k),'StartTime',0,'StartState',tmp);
               [S_BM,T] = simulate(BM, n, 'DeltaTime', dt, 'nTrials', 1);
           end 
           plot(T,S_BM)
           hold on
           axis([0 Tf -1500 6000]);
           xlabel(str1,'Interpreter','latex')
           ylabel(str2,'Interpreter','latex')
           title('Traffic Density Below Capacity')  
        end
        
% Random Arrivals
        subplot(3,1,3)
        for k = 1:nTrials
            for i = 1:n
               BM  = bm(Vspeed(k),sigma(k),'StartTime',0,'StartState',X0(k));
               [S_BM,T] = simulate(BM, n, 'DeltaTime', dt, 'nTrials', 1);
               X_tk(:,k) = S_BM(1:n);
               dudt = diff(S_BM)/dt;
               dudt(1:100) = Y_cld(1:100,k);
               U_tk(:,k)   = dudt;
            end
            plot(T,S_BM)
            axis([0 Tf -1500 6000]);
            hold on
            xlabel(str1,'Interpreter','latex')
            ylabel(str2,'Interpreter','latex')
            title('Traffic Density at Capacity') 
        end        
    saveas(gcf,'Figure2.pdf')
    save cT_SDE.mat
    end
 
