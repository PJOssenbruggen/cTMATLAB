function Step72
% LQR Controller
load('cT_Setup.mat')
Tf      = 10;
u       = u0;
dt      = Ts;
t       = 0:Ts:Tf;
tr      = t';
nr      = length(tr);

Speed  = ones(nr,1);
Loc    = ones(nr,1);
% State space model: one input
acc    = u0/10;         % acceleration feet per second^2
A      = [-b/m 0; Ts 1];
B      = eye(2);        % actuation on accelerating the vehicle.
B(1,1) = (Fd/m)
C      = eye(2);
D      = zeros(2);
sys    = ss(A,B,C,D,Ts)
for(i  = 1:length(tr))
    Speed(i) = acc*tr(i);
end
% Introduce closed loop
Q       = 10000*eye(2);
R       = 1;
[y0,t,x00] = lsim(sys,Speed,t); % x00 = speed
[K,S,e] = lqr(A,B,Q,R);

Acl     = (A-B*K);
Bcl     = B;
Ccl     = C;
Dcl     = D;
sys_cl  = ss(Acl,Nbar*Bcl,Ccl,Dcl);
[y,t,x] = lsim(sys_cl,u_star,t);        % x = y
[y, t, x]= lsim(sys_cl,Speed,t,[-s; 0]);
X_star = y(:,1);
U_star = y(:,2);

figure
subplot(2,1,1)
plot(t,X_star)
xlabel(str1,'Interpreter','latex')
ylabel(str17,'Interpreter','latex')
title('Target')

subplot(2,1,2)
plot(t,U_star)
hold on
% Compute LQR controller
Q      = eye(2);
R      = 10000;
[K,S,e]= lqr(A,B,Q,R);
Acl    = (A-B*K)        % Check this.
Bcl    = [0; 0];
C;
D;
sys_cl = ss(Acl,Bcl,C,D)
[y, t, x]= lsim(sys_cl,Speed,t,[-s; 0]);
X_star = y(:,1);
U_star = y(:,2);

figure
subplot(2,1,1)
plot(t,X_star)
xlabel(str1,'Interpreter','latex')
ylabel(str17,'Interpreter','latex')
title('Target')

subplot(2,1,2)
plot(t,U_star)
hold on

xlabel(str1,'Interpreter','latex')
ylabel(str18,'Interpreter','latex')
title('Target')   

% Kalman Filter
Vd      = eye(2);
Vd(1,1) = 0;
Vn      = eye(2);
Vn(1,1) = 0.8;  % The covariance matrix R  must be positive definite.
Vdn     = zeros(2);
% Compute using LQE
[L,P,E] = lqe(A,eye(2),C,Vd,Vn,Vdn);
Aest    = A-L*C;
Best    = L;
Cest    = eye(2);
Dest    = zeros(2);
sysK    = ss(Aest,Best,Cest,Dest)
nTrials = 1;
for k = 1:nTrials
    % Loop through 50 noise realizations
    for count = 1:50
        xd = X_star;                           % No disturbance in X(t)
        ud = U_star + Sigma*randn(nr,1);       % Disturbance in U(t)
        xn = xd   + 0.1 * Sigma*randn(nr,1);   % Noise in X(t)
        un = ud + 0.1 * Sigma*randn(nr,1);     % Noise in U(t)
        % Simulate Kalman filter 
        ZZ = [xn'; un'];
        [ahat, tout] = lsim(sysK, ZZ, t, [-s;0]);       
    end  
end
figure
subplot(2,1,1)
plot(t,X_star)
hold on
plot(t,xd)
hold on
plot(t,xn)
hold on
plot(t,ahat(:,1))
xlabel(str1,'Interpreter','latex')
ylabel(str17,'Interpreter','latex')
title('Target')

subplot(2,1,2)
plot(t,U_star)
hold on
plot(t,ud)
hold on
plot(t,un)
hold on
plot(t,ahat(:,2))
xlabel(str1,'Interpreter','latex')
ylabel(str18,'Interpreter','latex')
title('Target')     

end

