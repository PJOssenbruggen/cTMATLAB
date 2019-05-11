% Establish sys models: sys_cl and sys_cld.
function  cT_sys_cld(Qa,Ra,U0)
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
    x0 = U0;  % vehicle speed fps
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
    save y_cld.mat
end