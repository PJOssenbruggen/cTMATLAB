function cT_KalmanFilter(Q,R)
        load('cT_SDE.mat');
        load('cT_Setup.mat');
        load('cT_Trial_Table.mat');
        load('cT_Feedback.mat');
        load('cT_U0.mat');
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
% Calculate means and SDs
        W_mn  = 0*ones(nTrials-1,1);
        W_sd  = 0*ones(nTrials-1,1);
        Yf_mn = 0*ones(nTrials-1,1);
        Yf_sd = 0*ones(nTrials-1,1);
        Ym_mn = 0*ones(nTrials-1,1);
        Ym_sd = 0*ones(nTrials-1,1);
        for k = 1:nTrials
            W_mn(k)  = mean(W(100:n,k));
            W_sd(k)  = std(W(100:n,k));
            Yf_mn(k) = mean(Yf(100:n,k));
            Yf_sd(k) = std(Yf(100:n,k));
            Ym_mn(k) = mean(Ym(100:n,k));
            Ym_sd(k) = std(Ym(100:n,k));
        end
    
    T = table(W_mn, W_sd, Yf_mn, Yf_sd, Ym_mn, Ym_sd) 
%Plots     
        figure('Name','KalmanFilter')
        for k = 1:nTrials
            subplot(2,2,k)
            plot(t,W(:,k),'k-')
            hold on
            plot(t,Yf(:,k),'r-','LineWidth',3)
            hold on
            plot(t,Y_star,'b--','LineWidth',1)
            xlabel(str1,'Interpreter','latex')
            ylabel(str3,'Interpreter','latex')
            axis([0 60 0 120]);
            title(['Vehicle ',num2str(k),''])
            legend('w','y','u^*','Location','southeast')
        end 
        saveas(gcf,'Figure5.pdf')
end    