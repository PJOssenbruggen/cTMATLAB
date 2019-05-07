% Establish sys models: sys_cl and sys_cld.
function  cT_Feedback(Qa,Ra)
    load('cT_Setup.mat')
    A  = -b/m;
    B  = Fd/m;
    C  = 1;
    D  = 0;
    states  = {'speed'};
    inputs  = {'u'};
    outputs = {'y'};
    sys0 = ss(A,B,C,D,'statename',states,'inputname',inputs,'outputname',outputs);
    sys0.InputName;    % {'u'}  
    sys0.OutputName;   % {'y'} 
% LQR Analysis: sys_cl model with deterministic signal
    Na = 0;
    % Estimate targets
    x0 = u0;  % vehicle speed fps
    n  = size(t,1);
    u_star = x0*ones(n,1); % target speed
    x_star = 0*ones(n,1);  % target distance
    for i = 2:n
        x_star(i) = x_star(i-1) + dt*u0;
    end
    u     = Fd/m*ones(n,1);
    [y_sys0,t_sys0,x_sys0] = lsim(sys0,u,t);
    h_star = cT_SafeHeadway(x0,l);    % target headway
% Gain lqr of SISO model
    K    = lqr(A,B,Qa,Ra);
    Nbar = rscale(A,B,C,D,K);
    Ac   = (A-B*K);
    Bc   = B;
    Cc   = C;
    Dc   = D;
    states  = {'speed'};
    inputs  = {'u'};
    outputs = {'y'};
    sys_cl  = ss(Ac,Nbar*Bc,Cc,Dc,'statename',states,'inputname',inputs,'outputname',outputs);
    [y_cl,t_cl,x_cl] = lsim(sys_cl,u_star,t);
    tacc    = [7.77 7.77];
    yacc    = [0 1000];
    yacc1   = [0 120];
    % Convert from continuous to discrete model.
    sys_cld = c2d(sys_cl,Ts);
    [y_cld,t_cld,x_cld] = lsim(sys_cld,u_star);
    Y_star  = y_cld; % used in cT_KalmanFilter
% Plot
    figure('Name','Feedback')
    
    subplot(2,1,1)
    plot(t,y_sys0,'LineWidth',2)
    hold on
    plot(t,u_star,'m--')
    hold on
    plot(tacc,yacc,'r--')
    title('Model Without Feedback Control')
    legend('Open-Loop Model, ss_0', 'Target Speed, u^*','Comfortable acceleration = 10 fps^2.','Location','southeast')
    str = '$$ \textrm{Speed }\dot{x} \textrm{, feet per second (fps)} $$';
    ylabel(str,'Interpreter','latex')
    xlabel(str1,'Interpreter','latex') 
    ylabel(str3,'Interpreter','latex')
    
    subplot(2,1,2)
    plot(t,y_cl,'r-','LineWidth',3)
    hold on
    plot(t,y_cld,'y--','LineWidth',3)
    hold on
    plot(t,u_star,'m--')
    hold on
    plot(tacc,yacc1,'r--')
    hold on
    title('Model With Feedback Control')
    legend('Closed-Loop, ss_c_l', 'Closed-Loop ss_c_l_d','Target Speed, u^*','Comfortable acceleration = 10 fps^2.','Location','southeast')
    ylabel(str3,'Interpreter','latex')
    xlabel(str11,'Interpreter','latex') 
    saveas(gcf,'Figure1.pdf')
% Save data
    filename = 'cT_Feedback.mat';
    save cT_Feedback.mat 
end