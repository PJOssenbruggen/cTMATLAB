function cT_KalmanFilter(Q,R)
        load('cT_SDE.mat');
        load('cT_Setup.mat');
        load('cT_Trial_Table.mat');
        load('cT_Feedback.mat');
        load('U_tk.mat');
        W  = 0*ones(n,nTrials);
        Y  = 0*ones(n,nTrials);
        Yf = 0*ones(n,nTrials);
        Ym = 0*ones(n,nTrials);
        u_star = Y_star;
        [y_cld,t_cld,x_cld] = lsim(sys_cld,u_star);
% Establish a 'Plant' model.
        Plant = ss(sys_cld.A,[sys_cld.B sys_cld.B],sys_cld.C,0,-1,'inputname',{'u' 'w'},'outputname',{'y'});
        [kalmf,L,P,M] = kalman(Plant,Q,R);
        kalmf = kalmf(1,:);  
% Construct a 'P' model from the 'Plant' model.
        a = Plant.A;
        b = [Plant.B 0*Plant.B(:,1)];
        c = [Plant.C; Plant.C];
        d = [0 0 0; 0 0 1];
        P = ss(a,b,c,d,-1,'inputname',{'u' 'w' 'v'},'outputname',{'y' 'yv'});
% Construct a 'sys' or parallel model with the 'Plant'and 'kalmf' models.
        sys  = parallel(P,kalmf,'name');
% Construct a 'SimModel' or a feedback model with the 'sys'and 'kalmf' models.
        SimModel0 = feedback(sys,1,4,2,1);
% Delete yv and y from the 'SimModel0' model. by:
        SimModel = SimModel0([1 3],[1 2 3]);
% Introduce measurement noise and disturbances
        for k = 1:nTrials
            w = U_tk(:,k);
            v = sqrt(R)*randn(n,1);
            [out,tout, xout] = lsim(SimModel,[w,v,Y_star]);
% Simulate
            Y(:,k)   = out(:,1);           % true speed.
            Yf(:,k)  = out(:,2);           % filtered speed
            Ym(:,k)  = out(:,1) + v;       % measured speed  
            W(:,k)   = w;                  % Driver speed
        end
% Correct state-space steady-state error
        for k = 1:nTrials
            correct = Y_star(n,1)/mean(Yf(101:n,k));
            Yf(:,k) = correct*Yf(:,k);
            Ym(:,k) = correct*Ym(:,k);
        end
% Calculate means and SDs of KF speed: u_kf
    for k = 1:nTrials
        U_mn(k) = mean(Yf(101:n,k));
        U_sd(k) = std(Yf(101:n,k));
    end
    U_mn     = U_mn';
    U_sd     = U_sd';
    U_mps    = 0.3048*U_mn;
    U_sd_mps = 0.3048*U_sd;
    Vehicle  = [1:1:nTrials]';
    T = table(Vehicle, U_mn, U_sd, U_mps, U_sd_mps)
    
% Calculate means and SDs of KF speed: w
    for k = 1:nTrials
            W_mn(k) = mean(W(101:n,k));
            W_sd(k) = std(W(101:n,k));
    end
    W_mn     = W_mn';
    W_sd     = W_sd';
    W_mps    = 0.3048*W_mn;
    W_sd_mps = 0.3048*W_sd;
    T = table(Vehicle, W_mn, W_sd,W_mps,W_sd_mps) 
    
   
    
    
% Scale transformations: feet to m
    WSI      = 0.3048*W;
    YfSI     = 0.3048*Yf;
    Y_starSI = 0.3048*Y_star;
%Plots     
    figure('Name','KalmanFilter')
    for k = 1:nTrials
        subplot(2,2,k)
        plot(t,WSI(:,k),'k-')
        hold on
        plot(t,YfSI(:,k),'r-','LineWidth',3)
        hold on
        plot(t,Y_starSI,'b--','LineWidth',1)
        xlabel(str11,'Interpreter','latex')
        ylabel(str3,'Interpreter','latex')
        axis([0 60 0 40]);
        title(['Vehicle ',num2str(k),''])
        lgd = legend('w','y','u^*','Location','southeast');
        w = lgd.FontWeight;
        y = lgd.FontWeight;
        lgd.FontWeight = 'bold';
    end 
    saveas(gcf,'Figure5.pdf')
end    