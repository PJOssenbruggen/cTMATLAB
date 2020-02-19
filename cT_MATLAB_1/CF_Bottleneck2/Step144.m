function [KF Performance] = Step144(sys,u_star)
    load('cT_Setup.mat')
    % Plant
    sys_cld = c2d(sys,Ts);
    A       = sys_cld.A;
    B       = sys_cld.B;
    C       = sys_cld.C;
    D       = sys_cld.D;
    t       = 0:Ts:Tf;
    % Plant
    Plant = ss(A,[B B],C,D,-1,'inputname',{'u' 'w'},'outputname','y');
    % Discrete Kalman Filter
    Q = Sigma; 
    R = Sigma;
    [kalmf,L,P,M] = kalman(Plant,Q,R);
    % kalmf    M = gain
    a = A;
    b = [B B 0*B];
    c = [C;C];
    d = [0 0 0;0 0 1];
    P = ss(a,b,c,d,-1,'inputname',{'u' 'w' 'v'},'outputname',{'y' 'yv'});
    % Models
    kalmf        = kalmf(1,:);
    sys          = parallel(P,kalmf,1,1,[],[]);
    SimModel     = feedback(sys,1,4,2,1);   % Close loop around input #4 and output #2
    SimModel     = SimModel([1 3],[1 2 3]); % Delete yv from I/O list
    SimModel.InputName;
    SimModel.OutputName;
    % Noise and disturbance
    n            = length(t);
    t            = t';
    for count = 1:50
        w       = Q*randn(n,1);   % plant noise
        v       = R*randn(n,1);   % measurement noise
        u       = u_star(:,1);
        [out,x] = lsim(SimModel,[w,v,u]);
        y       = out(:,1);       % true response includes w noise
        ye      = out(:,2);       % filtered response
        yv      = y + v;          % measured response       
        KF      = [t, w, v, y, ye, yv, u];
        if count == 1
            data = [y(421) ye(421) yv(421) u(421)];
            Data = data;
        else
            data = [y(421) ye(421) yv(421) u(421)];
            Data = [Data; data];
        end
    end
    
    y_mn    = 0.3084*mean(Data(:,1));
    ye_mn   = 0.3084*mean(Data(:,2));
    yv_mn   = 0.3084*mean(Data(:,3));
    u_mn    = 0.3084*mean(Data(:,4));
    y_std   = 0.3084*std([Data(:,1)]);
    ye_std  = 0.3084*std([Data(:,2)]);
    yv_std  = 0.3084*std([Data(:,3)]);
    u_std   = 0.3084*std([Data(:,4)]);
    spd_std = [y_std; ye_std; yv_std; u_std];
    spd_mn  = [y_mn; ye_mn; yv_mn; u_mn];
    response= {'True';'Filtered';'Measured';'Reference'};
    Performance = table(response, spd_mn, spd_std);
      
end