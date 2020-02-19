function Z = Step102(xstart)
% LQR Controller
load('cT_Setup.mat')
Tf     = 30;
u      = u0;
dt     = Ts;
t      = 0:Ts:Tf;
tr     = t';
nr     = length(tr);
% State space model: one input
acc    = u0/10;         % acceleration feet per second^2
A      = [1 0; Ts 1];
B      = eye(2);        % actuation on accelerating the vehicle.
C      = eye(2);
D      = zeros(2);
sys    = ss(A,B,C,D,Ts)
Speed  = 0*ones(nr,1);
Loc    = 0*ones(nr,1);

for(i  = 1:100)         % 100 seconds
    if i == 1
    Speed(i) =  0;
    Loc(i)   =  -xstart;
    else
        Speed(i) = acc*t(i);
        Loc(i)   = Loc(i-1) + Speed(i)*Ts;
    end
end
for(i  = 101:nr)
    if i == 101
    Speed(i) =  u0;
    Loc(i)   =  Loc(100) + u0*Ts;
    else
        Speed(i) = u0;
        Loc(i)   = Loc(i-1) + u0*Ts;
    end
end
% Introduce closed loop
Q       = 100*eye(2);
R       = eye(2);
[y0,t,x00] = lsim(sys,[Speed';Loc'],t,[0;-xstart]); % x00 = speed
[K,S,e] = dlqr(A,B,Q,R);
Acl     = (A-B*K);
Bcl     = B;
Ccl     = C;
Dcl     = D;
sys_cl  = ss(Acl,Bcl,Ccl,Dcl,Ts)
[y,t,x] = lsim(sys_cl,[Speed';Loc'],t,[0;-xstart]);   
X_star  = y(:,2);
U_star  = y(:,1);
% Kalman Filter
Vd      = eye(2);
Vd(1,1) = Sigma*Vd(1,1);
Vd(2,2) = Ts*0.5*Sigma*Vd(1,1);
Vn      = eye(2);
Vn(1,1) = Sigma*Vn(1,1);
Vn(2,2) = Ts*0.5*Sigma*Vn(1,1);
Vdn     = zeros(2);
% Compute 
[L,P,E] = dlqe(A,eye(2),C,Vd,Vn,Vdn);
Aest    = A-L*C;
Best    = L;
Cest    = eye(2);
Dest    = zeros(2);
sysK    = ss(Aest,Best,Cest,Dest,Ts)
% Kalman filter
xd      = X_star + 0.5*Ts*Sigma*randn(nr,1);   % Disturbance in X(t)
ud      = U_star + Sigma*randn(nr,1);          % Disturbance in U(t)
xn      = 0.5*Ts*Sigma*randn(nr, 1);                   % Noise
un      = Sigma*randn(nr, 1); 
% Simulate noisy system
XX      = [ud'; xd'];
[S, tout] = lsim(sys_cl, XX, t, [0;-xstart]); 
% Simulate Kalman filter 
S(:,1)  = S(:,1) + un;
S(:,2)  = S(:,2) + xn;
sn      = S';
[ahat, that] = lsim(sysK, sn, t, [0;-xstart]);  
Xm      = S(:,2);
Um      = S(:,1);
Xkf     = ahat(:,2);
Ukf     = ahat(:,1);
Z       = [t X_star U_star Xm Um Xkf Ukf];  
end