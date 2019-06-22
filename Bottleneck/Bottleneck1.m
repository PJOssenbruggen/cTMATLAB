
close all
clc
clear all
cd /Users/PJO/Desktop/cT_MATLAB/Bottleneck
cT_Setup();
T_setup = table(g,W,m,Fd,u0,b,l);
T_setup
A = -b/m;
B = Fd/m;
C = 1;
D = 0;

cruise_ss = ss(A,B,C,D);
dt = 0.1;
t  = 0:dt:60;
n  = size(t,2);
x0 = 0;
u_star   = u0*ones(n,1);
for i = 1:100
    u_star(i) = u0/10*t(i);
end
z_star   = 0*ones(n,1);
[y,t,x]  = lsim(cruise_ss,u_star,t);
% Introduce closed loop
Q       = 1;
R       = 3;
T_LQR = table(u0, Q, R);
T_LQR
[K,S,e] = lqr(A,B,Q,R);
Acl     = A-B*K;
Bcl     = B;
Nbar    = rscale(A,B,C,D,K);
Acl     = (A-B*K);
Bcl     = B;
Ccl     = C;
Dcl     = D;
sys_cl  = ss(Acl,Nbar*Bcl,Ccl,Dcl);
[y,t,x] = lsim(sys_cl,u_star,t);
ssa     = sys_cl.B;
TF      = tf(sys_cl);
x_n     = 0*ones(n,1);
for i = 2:n
    x_n(i) = x_n(i-1) + y(i)*dt;      
end
save('CruiseControl2.mat','ssa')
for i = 1:n
    z_star(i) = 0 + u0*t(i);
end

T_model = table(m,Fd,b, Q, R, ssa);
T_model
figure
subplot(2,1,1)
    plot(t,y,'k-','LineWidth',2)
    hold on
    plot(t,u_star,'r--','LineWidth',1)
    axis([0 60 0 90]);
    title('LQR Model Forecasts')
    legend('u(t)','u^*','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')
    text(6.3,40,'\leftarrow LQR(Q,R) = LQR(1,3)')
subplot(2,1,2)
    plot(t,x_n,'k-','LineWidth',2)
    hold on
    plot(t,z_star,'r--','LineWidth',1);
    axis([0 60 0 5000]);
    legend('x(t)','x^*','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')
x0=10;
y0=10;
width=550;
height=700;
set(gcf,'position',[x0,y0,width,height]) 
cd /Users/PJO/Desktop/cT_MATLAB/Simulink
saveas(gcf,'CruiseControl_1.pdf')
y_SI = 0.3048*y;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lead Nonlinear Acceleration
Tstart = 20;
Tend   = 25;
Ts     = dt;
Ustart = u0;
Uend   = u0;
Xstart = x0 + u0*(Tstart);
Xend   = x0 + u0*(Tend) + 5280/45/2;
ab     = CruiseAccel(Tstart,Tend,Ts,Ustart,Uend,Xstart,Xend);
tN     = Tstart:Ts:Tend;
nN     = size(tN,2);
ab     = CruiseAccel(Tstart,Tend,Ts,Ustart,Uend,Xstart,Xend);
T_lead = table(Tstart,Tend,dt,Ustart,Uend,Xstart,Xend);
T_lead
for i = 1:nN
    x(i)   = Xstart + Ustart * (tN(i)-Tstart) + ab(1)/2 * (tN(i)-Tstart)^2 - ab(2)/6 * (tN(i)-Tstart)^3;
    u(i)   = Ustart + ab(1) * (tN(i)-Tstart) - ab(2)/2 * (tN(i)-Tstart)^2;
    acc(i) = ab(1) - ab(2) * (tN(i) - Tstart);
    xl(i)  = Ustart * (tN(i) - Tstart);
end
% Alter u_star
j = 0;
u_starN = u_star;
for i = 1:n
    if t(i) < Tstart
        u_starN(i) = y(i);
    end
    if t(i) >= Tstart & t(i) <= Tend
        j = j+1;
        u_starN(i) = u(j);
    end
end
[u_N,t,x] = lsim(sys_cl,u_starN,t);
x_N = 0*ones(n,1);
for i = 2:n
       x_N(i) = x_N(i-1) + u_starN(i)*dt;      
end
% Follow Nonlinear Acceleration
Ustart = u0;
Uend   = u0;
Xstart = x0 + u0*(Tstart);
Xend   = x0 + u0*(Tend) - 5280/45/2;
ab     = CruiseAccel(Tstart,Tend,Ts,Ustart,Uend,Xstart,Xend);
T_follow = table(Tstart,Tend,dt,Ustart,Uend,Xstart,Xend);
T_follow
for i = 1:nN
    x(i)   = Xstart + Ustart * (tN(i)-Tstart) + ab(1)/2 * (tN(i)-Tstart)^2 - ab(2)/6 * (tN(i)-Tstart)^3;
    u(i)   = Ustart + ab(1) * (tN(i)-Tstart) - ab(2)/2 * (tN(i)-Tstart)^2;
    acc(i) = ab(1) - ab(2) * (tN(i) - Tstart);
    xf(i)  = Ustart * (tN(i) - Tstart);
end
% Alter u_star
j = 0;
u_starF = u_star;
for i = 1:n
    if t(i) < Tstart
        u_starF(i) = y(i);
    end
    if t(i) >= Tstart & t(i) <= Tend
        j = j+1;
        u_starF(i) = u(j);
    end
end
[u_F,t,x] = lsim(sys_cl,u_starF,t);
x_F = 0*ones(n,1);
for i = 2:n
       x_F(i) = x_F(i-1) + u_starF(i)*dt;      
end

% Lead vehicle
figure
subplot(2,1,1)
    plot(tN,acc,'k-','LineWidth',2)
    xlabel(str1,'Interpreter','latex')
    title('Following Vehicle')
    ylabel(str19,'Interpreter','latex')
   % legend('Lead vehicle','Following Vehicle','Location','northwest')

subplot(2,1,2)
    plot(tN,u,'k-','LineWidth',2)
    hold on
    umin = -10 + min(u);
    umax = 10  + max(u);
    axis([Tstart Tend  umin umax]);
    xlabel(str1,'Interpreter','latex')
    ylabel(str18,'Interpreter','latex')
x0=10;
y0=10;
width=550;
height=700;
set(gcf,'position',[x0,y0,width,height])    
saveas(gcf,'CruiseControl_2.pdf')
u_SI = 0.3048*u;

figure
subplot(2,1,1)
    plot(t,u_starN,'k-','LineWidth',2)
    hold on
    plot(t,u_starF,'b--','LineWidth',2)
    hold on
    plot(t,u_star,'r--','LineWidth',1)
    axis([0 60 0 120]);
    title('Assisted Car Following')
    legend('u_l_e_a_d(t)','u_f_o_l_l_o_w(t)','u^*','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')
    text(5,200,'\leftarrow LQR(Q,R) = LQR(1,40)')
subplot(2,1,2)
    plot(t,x_N,'k-','LineWidth',2)
    hold on
    plot(t,x_F,'b--','LineWidth',2)
    hold on
    plot(t,z_star,'r--','LineWidth',1);
    axis([0 60 0 5000]);
    legend('x_l_e_a_d(t)','x_f_o_l_l_o_w(t)','x^*','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')
x0=10;
y0=10;
width=550;
height=700;
set(gcf,'position',[x0,y0,width,height]) 
saveas(gcf,'CruiseControl_3.pdf')
time = 60;
x_nodelay  = max(x_n);
x_lead     = max(x_N);
x_follow   = max(x_F);
h_capacity = 5280/45;
gap_rule   = h_capacity/l - 1;
gap_CF     = (x_lead - x_follow)/l - 1;
max_u      = max(u_starN);
T_ab = table(time, x_nodelay, x_lead, h_capacity, gap_rule, gap_CF, max_u)
T_ab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kalman Filter Continous Model
sys_cl;
% Plant
A       = sys_cl.A;
B       = sys_cl.B;
C       = sys_cl.C;
D       = sys_cl.D;
Plant = ss(A,[B B],C,D,'inputname',{'u' 'w'},'outputname','y');
Plant;
% Continuous Kalman Filter
[kalmf,L,P,M] = kalman(Plant,Q,R);
kalmf;    
a = A;
b = [B B 0*B];
c = [C;C];
d = [0 0 0;0 0 1];
P = ss(a,b,c,d,'inputname',{'u' 'w' 'v'},'outputname',{'y' 'yv'});
P;
% Noise and disturbance
sigmaU = 1;
rng(123)
w = sigmaU*randn(n,1);
v = sigmaU*randn(n,1);
% SimModel
[ykf,t,xkf]  = lsim(kalmf,[u_starN,w],t);
sys          = parallel(P,kalmf,'name');
SimModel     = feedback(sys,1,4,2,1);   % Close loop around input #4 and output #2
SimModel     = SimModel([1 3],[1 2 3]); % Delete yv from I/O list
SimModel;
% FORECAST 3
u            = u_starN;
[out,x]      = lsim(SimModel,[w,v,u],t);
y  = out(:,1);  % true response
ye = out(:,2);  % filtered response
yv = y + v;     % measured response
[y,t,x] = lsim(sys_cl,u_starN,t);

% Plots

figure
subplot(2,1,1)
    plot(t,u_starN,'b--')
    hold on
    plot(t,y,'k-','LineWidth',1)
    hold on
    plot(t,ye,'k-')
    hold on
    plot(t,yv,'r-')
    axis([0 60 0 110])
    title('An Assisted Driver')
    legend('u^*','u_t_r_u_e','u_K_F','u_o_b_s_e_r_v_e_d','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str18,'Interpreter','latex')
subplot(2,1,2)
    plot(t,y-ye,'k-')
    hold on
    plot(t,y-yv,'r-')
    xlabel(str1,'Interpreter','latex')
    ylabel(str22,'Interpreter','latex')
    axis([0 60 -4 4])
    title('')
    legend('u_t_r_u_e - u_K_F','u_t_r_u_e - u_o_b_s_e_r_v_e_d')
x0=10;
y0=10;
width=550;
height=700;
set(gcf,'position',[x0,y0,width,height]) 
saveas(gcf,'CruiseControl_8.pdf')

MeasErr = y-yv;
MeasErrCov = sum(MeasErr.*MeasErr)/length(MeasErr);
EstErr = y-ye;
EstErrCov = sum(EstErr.*EstErr)/length(EstErr);

CovError = table(MeasErrCov, EstErrCov)

% SI plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot(2,1,1)
    plot(t,y_SI,'k-','LineWidth',2)
    hold on
    plot(t,0.3048*u_star,'r--','LineWidth',1)
    axis([0 60 0 0.3048*90]);
    title('LQR Model Forecasts')
    legend('u(t)','u^*','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')
    text(6.3,0.3048*40,'\leftarrow LQR(Q,R) = LQR(1,3)')
subplot(2,1,2)
    plot(t,0.3048*x_n,'k-','LineWidth',2)
    hold on
    plot(t,0.3048*z_star,'r--','LineWidth',1);
    axis([0 60 0 0.3048*5000]);
    legend('x(t)','x^*','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')
x0=10;
y0=10;
width=550;
height=700;
set(gcf,'position',[x0,y0,width,height]) 
cd /Users/PJO/Desktop/cT_MATLAB/Bottleneck
saveas(gcf,'Figure2.pdf')

% Lead vehicle
figure
subplot(2,1,1)
    plot(tN,acc,'k-','LineWidth',2)
    xlabel(str1,'Interpreter','latex')
    title('Following Vehicle')
    ylabel(str19,'Interpreter','latex')
   % legend('Lead vehicle','Following Vehicle','Location','northwest')

subplot(2,1,2)
    plot(tN,u_SI,'k-','LineWidth',2)
    hold on
    umin = -0.3048*0.10 + min(u_SI);
    umax = 0.3048*10  + max(u_SI);
    axis([Tstart Tend  umin umax]);
    xlabel(str1,'Interpreter','latex')
    ylabel(str18,'Interpreter','latex')
x0=10;
y0=10;
width=550;
height=700;
set(gcf,'position',[x0,y0,width,height]) 
cd /Users/PJO/Desktop/cT_MATLAB/Simulink
saveas(gcf,'CruiseControl_2SI.pdf')

figure
subplot(2,1,1)
    plot(t,0.3048*u_starN,'k-','LineWidth',2)
    hold on
    plot(t,0.3048*u_starF,'b--','LineWidth',2)
    hold on
    plot(t,0.3048*u_star,'r--','LineWidth',1)
    axis([0 60 0 0.3048*120]);
    title('A Safe Side-by-Side Merge')
    legend('u_l_e_a_d(t)','u_f_o_l_l_o_w(t)','u^*','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')
    text(5,0.3048*200,'\leftarrow LQR(Q,R) = LQR(1,40)')
subplot(2,1,2)
    plot(t,0.3048*x_N,'k-','LineWidth',2)
    hold on
    plot(t,0.3048*x_F,'b--','LineWidth',2)
    hold on
    plot(t,0.3048*z_star,'r--','LineWidth',1);
    axis([0 60 0 0.3048*5000]);
    legend('x_l_e_a_d(t)','x_f_o_l_l_o_w(t)','x^*','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')
x0=10;
y0=10;
width=550;
height=700;
set(gcf,'position',[x0,y0,width,height]) 
cd /Users/PJO/Desktop/cT_MATLAB/Bottleneck
saveas(gcf,'Figure3.pdf')

figure
subplot(2,1,1)
  
    plot(t,0.3048*y,'k--')
    hold on
    plot(t,0.3048*ye,'b-','LineWidth',2)
    hold on
    plot(t,0.3048*yv,'r-')
    axis([0 60 0 0.3048*110])
    title('An Assisted Driver')
    legend('u^*','u_K_F','y','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')
subplot(2,1,2)
    plot(t,0.3048*(y-ye),'b-','LineWidth',2)
    hold on
    plot(t,0.3048*(y-yv),'r-')
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')
    axis([0 60 -0.3048*4 0.3048*4])
    title('Error')
    legend('u^* - u_K_F','u^* - y')
x0=10;
y0=10;
width=550;
height=700;
set(gcf,'position',[x0,y0,width,height]) 
saveas(gcf,'Figure6.pdf')