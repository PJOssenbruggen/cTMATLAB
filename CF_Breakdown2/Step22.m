function Step22(nTrials)
    % Simulate nTrials of U and X
    load('cT_Setup.mat')
    rng(seed)
    T_setup
    T_setup2
    global U X;
    % Brownian Motion of Speed 0 to 60 seconds
    Tf      = 60;
    t       = 0:Ts:Tf;
    n       = size(t,2);
    U       = u0*ones(n,nTrials);  % Speed
    X       = zeros(n,nTrials);    % Location 
    U10     = 0*ones(100,nTrials); % Speed from time 0 to 10 seconds
    F       = @(t,X) 0;
    G       = @(t,X) Sigma;
    obj_U   = sde(F, G,'StartState',0);
    [Ut,T]  = simulate(obj_U, n-1, 'DeltaTime', Ts,'nTrials',nTrials);
    for k = 1:nTrials
        U(:,k)  = U(:,k) + Ut(:,:,k);
    end
    % Brownian Motion of Speed 0 to 10 seconds
    Tf      = 10;
    t       = 0:Ts:Tf;
    n       = size(t,2);
    b0      = U(100,:)/10;
    % Constant acceleration rate
    for k = 1:nTrials
    F1      = @(t,X) b0(k);
    G1      = @(t,X) Sigma;
    obj_U   = sde(F1, G1,'StartState',0);
    [Ut,T]  = simulate(obj_U,n-2,'DeltaTime', Ts,'nTrials',1);
    U10(:,k)= Ut; 
    end
    for k = 1:nTrials
        U(1:100,k) = U10(:,k);
    end
    Tf      = 60;
    t       = 0:Ts:Tf;
    Tf      = 60;
    t       = 0:Ts:Tf;
    n       = size(t,2);
    % headway spacing between vehicles
    m       = 0:nTrials-1;         % lead vehicle
    X(1,:)  = -s*m;
    for k = 1:nTrials
        for i = 2:n
            X(i,k) = X(i-1,k) + 0.5*(U(i-1,k) + U(i,k))*Ts;
        end
    end
end


