% Calculate speed from a Brownian Motion Model of speed.
clear all
close all
clear global K_t
clc
cd /Users/PJO/Desktop/cT_MATLAB
load('cT_Setup.mat')

% Plot locations from the model
    mu    = u0;
    sigma = 5;
    dt    = 0.1;
    BM  = bm(mu,sigma,'StartTime',0,'StartState',0);
    [S_BM,T] = simulate(BM, n, 'DeltaTime', dt, 'nTrials', 1); 
    u_star = u0*ones(n,1); % target speed
    x_star = 0*ones(n,1);  % target distance
    for i = 2:n
        x_star(i) = x_star(i-1) + dt*u0;
    end
% Estimate the speed from the location simulation model
    u_BM = diff(S_BM)/dt;
    dudt = diff(S_BM)/dt;
    u_BM = dudt;
% Etimate x from u_BM
    x    = 0*ones(n,1);
    for i = 2:n
        x(i) = x(i-1) + dt*u_BM(i-1);
    end
    
% Plot results
    figure('Name','BM speed model.')
    subplot(2,1,1)
    plot(t,u_BM,'r-')
    hold on
    plot(t,u_star,'b--')
    title('Vehicle Speeds')
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')
    legend('\mu = 77.7 \sigma = 5', 'Target Speed','Location','southeast')
    
    
    subplot(2,1,2)
    plot(T,S_BM,'r-','LineWidth',3)
    hold on
    plot(t,x,'y--')
    hold on
    plot(t,x_star,'b--')
    axis([0 Tf 0 5000]);
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')
    title('Ideal Conditions') 