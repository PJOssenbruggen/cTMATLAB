
function [X0,U0,Sigma] = cT_U0(nTrials,Vspeed,sigma)
    load('cT_Feedback.mat');

    Vehicle = [1:1:nTrials]';
    h0    = cT_SafeHeadway(Vspeed(2:nTrials),l); % Safe headways
    h0    = [0 ; h0];
    X0    = -1*cumsum(h0);
    n0    = 1*ones(n,1);
    U0    = 0*ones(n,nTrials);
    Sigma = 0*ones(n,nTrials);
    for k = 1:nTrials
        U0(:,k)    = Vspeed(k)*n0;
        Sigma(:,k) = sigma(k)*n0;
    end
    T = table(Vehicle,Vspeed,sigma,h0)
    save('cT_Feedback.mat', 'T')
% Assume deterministic process for 10 seconds.
    Y_cld = 0*ones(n,nTrials);
    for k = 1:nTrials
        tmp = Vspeed(k);
        cT_sys_cld(Qa,Ra,tmp);
        load('y_cld.mat')
        Y_cld(:,k) = y_cld;
    end
    save cT_U0.mat
end

    