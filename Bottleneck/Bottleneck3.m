% time - location and time - speed trajectories
clear all
close all
clc

cd /Users/PJO/Desktop/cT_MATLAB/Bottleneck
cT_Setup()
load('CruiseControl2.mat','ssa')
for run = 1:2
    if run == 1
        rng(129)
    else
        rng(632)
    end
    ntrials = 4;
    % x = location 
    Ts = 0.1;
    Tf = 20;
    % Start up PHASE 1
    t  = 0:Ts:10;
    n1 = size(t,2);
    x0 = 0;
    b0 = u0/10;  % slope
    % location
    sigmaX = 1;
    trial  = 8.38;
    for i = 1:n1
        x1(i) = x0 + 0.5*b0*t(i)^2;
        x1_star(i) = x0 + u0*t(i);
    end
    % speed
    sigmaU = 1;
    x02     = -rand * trial * l;
    x03     = - trial * l;
    x04     = x02 - trial * l;
    Xstart1 = [0; x02; x03; x04];
    U1      = zeros(n1,ntrials);
    X1      = zeros(n1,ntrials);
    for j = 1:ntrials
        F1 = @(t,X1) b0;
        G1 = @(t,X1) sigmaU;
        obj_U1 = sde(F1, G1,'StartState',0);
        [U1t,T] = simulate(obj_U1, n1, 'DeltaTime', Ts, 'nTrials', 1);
        U1t     = reshape(U1t,n1+1,1);
        U1(:,j) = U1t(1:n1,:);
        F1 = @(t,X1) b0*t;
        G1 = @(t,X1) sigmaX;
        obj_X1  = sde(F1, G1,'StartState',Xstart1(j));
        [X1t,T] = simulate(obj_X1, n1, 'DeltaTime', Ts, 'nTrials', 1);
        X1t     = reshape(X1t(1:n1,:),n1,1);
        X1(:,j) = X1t(1:n1,:);
    end
    for i = 1:n1
        u1(i)      =  b0*t(i);
        u1_star(i) = u0;
    end

    T1 = table(u0,x0,ssa,b0,sigmaX,sigmaU,n1,ntrials);
    T1
    % Phase II. 
    t  = T(n1):Ts:Tf;
    n2 = size(t,2);
    x0 = max(x1);
    U2 = zeros(n2,ntrials);

    F2 = @(t,U2) ssa^-2 * exp(-ssa*t);
    G2 = @(t,U2) sigmaU;
    for j = 1:ntrials
       obj_U2  = sde(F2, G2,'StartState',U1(n1,j),'StartTime',10);
       [U2t,T] = simulate(obj_U2, n2, 'DeltaTime', Ts, 'nTrials', 1);
       U2t     = reshape(U2t,n2+1,1);
       U2(:,j) = U2t(1:n2,:);
    end
    for i = 1:n2
        u2(i) =  u0;
        u2_star(i) = u0;
    end
    F2 = @(t,X1) u0 + ssa^-1 * exp(-ssa*t);
    G2 = @(t,X1) sigmaX;
    X2 = zeros(n2,ntrials);
    for j = 1:ntrials
        obj_X2  = sde(F2, G2,'StartState',X1(n1,j),'StartTime',10);
        [X2t,T] = simulate(obj_X2, n2, 'DeltaTime', Ts, 'nTrials', 1);
        X2t     = reshape(X2t(1:n2,:),n2,1);
        X2(:,j) = X2t(1:n2,:);
    end
    for i = 1:n2
        x2(i) = x0 + u0*(t(i)-10) + ssa^-2 * exp(-ssa*(t(i)-10));
        x2_star(i) = x0 + u0*t(i);
    end

% Join Phase 1 and 2
t = 0:Ts:Tf;
n = length(t);
U = [U1; U2];
U = U(1:n,:);
X = [X1; X2];
X = X(1:n,:);
u = [u1 u2];
u = u(1:n);
x = [x1 x2];
x = x(1:n);
Ustart2 = U(n,:)';
Xstart2 = X(n,:)';

% Phase III. 
t         = 0:Ts:5;
n3        = size(t,2);
x0        = max(x1);
Tstart    = 0;
Tend      = 5;
U3        = zeros(n3,ntrials);
X3        = zeros(n3,ntrials);
Tf        = 25;
tf        = 0:Ts:Tf;
nf        = size(tf,2);
% Bottleneck: Driver decisions
for j = 1:ntrials
   Ustart = U(n,j);
   Xstart = X(n,j);  
   if j == 1
       Uend      = u0;
       Xend      = X(n,j) + u0*5;
       cT_AccelParam(Tstart,Tend,Ustart,Uend,Xstart,Xend);
       load('cT_ab.mat')
       a         = ab(1);
       b         = ab(2);
       Atab      = [a];
       Btab      = [b];
       ustarttab = Ustart;
       uendtab   = Uend;
       xstarttab = Xstart;
       xendtab   = Xend;
   end
   % Following vehicles cannot exceed speed of lead vehicles
   if j > 1
       Uend      = min([u0,U(n,1:j-1)]); 
       Xend      = min(X3(n3,1:j-1))  - l * trial;
       cT_AccelParam(Tstart,Tend,Ustart,Uend,Xstart,Xend);
       load('cT_ab.mat')
       a         = ab(1);
       b         = ab(2);
       Atab      = [Atab;a];
       Btab      = [Btab;b];
       ustarttab = [ustarttab;Ustart];
       uendtab   = [uendtab;Uend];
       xstarttab = [xstarttab;Xstart];
       xendtab   = [xendtab;Xend];
   end 
   F3       = @(t,U) a -  b * t;
   G3       = @(t,U) sigmaU;
   obj_U3   = sde(F3, G3,'StartState',Ustart,'StartTime',0);
   [U3t,T]  = simulate(obj_U3, n3, 'DeltaTime', Ts, 'nTrials', 1);
   U3t      = reshape(U3t,n3+1,1);
   U3(:,j)  = U3t(1:n3,:);
   F3       = @(t,U) Ustart + a*t - 0.5*b*t^2;
   G3       = @(t,U) sigmaU;
   obj_X3   = sde(F3, G3,'StartState',Xstart,'StartTime',0);
   [X3t,T]  = simulate(obj_X3, n3, 'DeltaTime', Ts, 'nTrials', 1);
   X3t      = reshape(X3t(1:n3,:),n3,1);
   X3(:,j)  = X3t(1:n3,:);
  
    end
    U = [U1(1:n1-1,:); U2(1:n2-1,:); U3(1:n3,:)];
    X = [X1(1:n1-1,:); X2(1:n2-1,:); X3(1:n3,:)];
    vehicle    = [1:4]';
    s3         = [0;diff(xendtab)];
    tab_AB  = table(vehicle,Atab,Btab,ustarttab,uendtab,xstarttab,xendtab,s3/l)
   
    tab_AB_SI  = table(vehicle,Atab,0.3048*Btab,0.3048*ustarttab,0.3048*uendtab,0.3048*xstarttab,0.3048*xendtab,s3/i)
    if run == 1
        Umat = U;
        Xmat = X;
    else
        Umat = [Umat U];
        Xmat = [Xmat X];
    end

end

% plot
figure
tf = [0:Ts:25];
% speed
subplot(2,2,1)
    plot(tf,0.3048*Umat(:,1),'LineWidth',2)
    hold on
    plot(tf,0.3048*Umat(:,2),'LineWidth',2)
    hold on
    plot(tf,0.3048*Umat(:,3),'LineWidth',2)
    hold on
    plot(tf,0.3048*Umat(:,4),'LineWidth',2)
    title('Run 1')
    axis([0 25 0 0.3048*100])
    legend('Vehicle 1','Vehicle 2','Vehicle 3','Vehicle 4','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')
     
subplot(2,2,3)
    plot(tf,0.3048*Xmat(:,1),'LineWidth',2)
    hold on
    plot(tf,0.3048*Xmat(:,2),'LineWidth',2)
    hold on
    plot(tf,0.3048*Xmat(:,3),'LineWidth',2)
    hold on
    plot(tf,0.3048*Xmat(:,4),'LineWidth',2)
    title('')
    axis([0 25 -0.3048*300 0.3048*1700])
    legend('Vehicle 1','Vehicle 2','Vehicle 3','Vehicle 4','Location','northwest')
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')
 subplot(2,2,2)
    plot(tf,0.3048*Umat(:,5),'LineWidth',2)
    hold on
    plot(tf,0.3048*Umat(:,6),'LineWidth',2)
    hold on
    plot(tf,0.3048*Umat(:,7),'LineWidth',2)
    hold on
    plot(tf,0.3048*Umat(:,8),'LineWidth',2)
    title('Run 2')
    axis([0 25 0 0.3048*100])
    legend('Vehicle 1','Vehicle 2','Vehicle 3','Vehicle 4','Location','southeast')
    xlabel(str1,'Interpreter','latex')
    ylabel(str3,'Interpreter','latex')
     
subplot(2,2,4)
    plot(tf,0.3048*Xmat(:,5),'LineWidth',2)
    hold on
    plot(tf,0.3048*Xmat(:,6),'LineWidth',2)
    hold on
    plot(tf,0.3048*Xmat(:,7),'LineWidth',2)
    hold on
    plot(tf,0.3048*Xmat(:,8),'LineWidth',2)
    title('')
    axis([0 25 -0.3048*300 0.3048*1700])
    legend('Vehicle 1','Vehicle 2','Vehicle 3','Vehicle 4','Location','northwest')
    xlabel(str1,'Interpreter','latex')
    ylabel(str2,'Interpreter','latex')
width=550;
height=700;
set(gcf,'position',[0,0,width,height])

cd /Users/PJO/Desktop/cT_MATLAB/Bottleneck
saveas(gcf,'Figure5.pdf')




