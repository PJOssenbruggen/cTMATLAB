function Step8
load('cT_Setup.mat')
global Unew;
% Kalman filter
clc
A       = [-b/m];
B       = [1/m];
C       = [1];
D       = [0];
sys_cld = ss(A,B,C,D,-1);
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
% FORECAST 1

%[ycld,t,xcld]= lsim(sys_cld,[u_star],t);

% Models
kalmf        = kalmf(1,:);

% FORECAST 2
%[ykf,t,xkf]  = lsim(kalmf,[ycld,u_star],t);
sys          = parallel(P,kalmf,1,1,[],[]);
SimModel     = feedback(sys,1,4,2,1);   % Close loop around input #4 and output #2
SimModel     = SimModel([1 3],[1 2 3]); % Delete yv from I/O list
clc
SimModel.InputName
SimModel.OutputName

% Noise and disturbance
t = 0:1:200';
n = length(t);
w = Q*randn(n,1);
v = R*randn(n,1);
u = u0*ones(n,1);
%for i = 1:100
%    u_star(i) = u0/100*t(i);
%end
%w = Unew(1:n,1);
w = Q*randn(n,1);
v = R*randn(n,1);
%figure
%plot(t,u_star)

% FORECAST 3
[out,x]      = lsim(SimModel,[w,v,u]);
y  = out(:,1);  % true response includes w noise
ye = out(:,2);  % filtered response
yv = y + v;     % measured response
KFtable = table(w, v, y, ye, yv, u)
% Plots
figure
subplot(2,1,1)
plot(t,y,'k-')
hold on
plot(t,ye,'r-')
hold on
%plot(t,w,'b--')
%axis([0 n 0 100])
title('sys_c_l_d')
legend('y','y_e','Location','southeast')
xlabel(str21,'Interpreter','latex')
ylabel(str18,'Interpreter','latex')
subplot(2,1,2)
plot(t,y-yv,'b-')
hold on
plot(t,y-ye,'k-')
hold on
%axis([0 200 0 100])
title('kalmf')
legend('y-y_v','y-y_e','Location','southeast')
xlabel(str21,'Interpreter','latex')
ylabel(str18,'Interpreter','latex')

end
