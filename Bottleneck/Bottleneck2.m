clc
clear all
close all
cd /Users/PJO/Desktop/cT_MATLAB/Bottleneck
rng(123)

load('cT_Setup.mat')
Tstart = 0;
Tend   = 5;
sigma  = 1;
trial  = 8.38; % WARNING: trial is the number of car lengths
carlengths = trial;
for run = 1:2
    if run == 1
        % Zipper
        Xstart1  = 0;
        Xend1    = u0*Tend;
        Xstart2  = Xstart1 - carlengths * l; 
        Xend2    = Xend1 - carlengths * l;   
        Xstart3  = Xstart2 - carlengths * l; 
        Xend3    = Xend2 - carlengths * l;
        Xstart4  = Xstart3 - carlengths * l; 
        Xend4    = Xend3 - carlengths * l; 
    end
    if run == 2
        % SBS
        Xstart1  = 0;
        Xend1    = u0*Tend;
        Xend2    = Xend1 - carlengths * l;   
        Xstart2  = 0;                       
        Xstart3  = - carlengths * l;         
        Xend3    = Xend2 - carlengths * l;
        Xstart4  = - carlengths * l;         
        Xend4    = Xend3 - carlengths * l; 
    end
    % Estimate averege a, average b, pbrkdn, minimum speed, maximum location
    nbrkdn1= 0;
    nbrkdn2= 0;
    nbrkdn3= 0;
    nbrkdn4= 0;
    N      = 100;
    a_1    = zeros(N,1);
    b_1    = zeros(N,1);
    a_2    = zeros(N,1);
    b_2    = zeros(N,1);
    a_2    = zeros(N,1);
    b_3    = zeros(N,1);
    a_3    = zeros(N,1);
    b_4    = zeros(N,1);
    u_1    = zeros(N,1);
    x_1    = zeros(N,1);
    u_2    = zeros(N,1);
    x_2    = zeros(N,1);
    u_3    = zeros(N,1);
    x_3    = zeros(N,1);
    u_4    = zeros(N,1);
    x_4    = zeros(N,1);
    t      = 0:Ts:Tend;
    n      = size(t,2);
    y00    = zeros(n,1);
    for sample = 1:N
        % Vehicle 1 Constant speed
        Vehicle = 1;
        Ustart  = u0;
        Uend    = u0;
        cT_AccelParam(Tstart,Tend,Ustart,Uend,Xstart1,Xend1);
        load('cT_ab.mat');
        a       = ab(1);
        b       = ab(2);
        Atab    = [a];
        Btab    = [b];
        xstart  = [Xstart1];
        xend    = [Xend1];
        F1      = @(t,X) a  - b * t;
        G1      = @(t,X) sigma;
        obj_U1   = sde(F1, G1,'StartState',u0);
        [S_U1,T] = simulate(obj_U1, n, 'DeltaTime', Ts, 'nTrials', 1);

        F1 = @(t,X) Ustart + a*t - 0.5*b*t^2;
        G1 = @(t,X) sigma;
        obj_X1   = sde(F1, G1,'StartState',Xstart1);
        [S_X1,T] = simulate(obj_X1, n, 'DeltaTime', Ts, 'nTrials', 1);
        U_min    = min(S_U1);
        % crash probability
        if U_min <= 0
          nbrkdn1= nbrkdn1 + 1;
        end
        u_1(sample) = U_min;
        a_1(sample) = a;
        b_1(sample) = b;

        % Vehicle 2 Decelerates
        Vehicle = 2;
        Ustart  = u0;
        Uend    = u0;
        cT_AccelParam(Tstart,Tend,Ustart,Uend,Xstart2,Xend2);
        load('cT_ab.mat');
        a       = ab(1);
        b       = ab(2);
        Atab    = [Atab;a];
        Btab    = [Btab;b];
        F2 = @(t,X) a - b * t;
        G2 = @(t,X) sigma;
        obj_U2   = sde(F2, G2,'StartState',u0);
        [S_U2,T] = simulate(obj_U2, n, 'DeltaTime', Ts, 'nTrials', 1);
        F2 = @(t,X) Ustart + a*t - 0.5*b*t^2;
        G2 = @(t,X) sigma;
        obj_X2   = sde(F2, G2,'StartState',Xstart2);
        [S_X2,T] = simulate(obj_X2, n, 'DeltaTime', Ts, 'nTrials', 1);
        U_min    = min(S_U2);
        % crash probability
        if U_min <= 0
          nbrkdn2 = nbrkdn2 + 1;
        end
        u_2(sample) = U_min;
        a_2(sample) = a;
        b_2(sample) = b;

        % Vehicle 3 Decelerates
        Vehicle = 3;
        Ustart  = u0;
        Uend    = u0;
        cT_AccelParam(Tstart,Tend,Ustart,Uend,Xstart3,Xend3);
        load('cT_ab.mat')
        a       = ab(1);
        b       = ab(2);
        Atab    = [Atab;a];
        Btab    = [Btab;b];
        F3      = @(t,X) a -  b * t;
        G3      = @(t,X) sigma;
        obj_U3  = sde(F3, G3,'StartState',u0);
        [S_U3,T]= simulate(obj_U3, n, 'DeltaTime', Ts, 'nTrials', 1);
        F3 = @(t,X) Ustart + a*t - 0.5*b*t^2;
        G3 = @(t,X) sigma;
        obj_X3   = sde(F3, G3,'StartState',Xstart3);
        [S_X3,T] = simulate(obj_X3, n, 'DeltaTime', Ts, 'nTrials', 1);
        U_min    = min(S_U3);
        % crash probability
            if U_min <= 0
              nbrkdn3 = nbrkdn3 + 1;
            end
        u_3(sample) = U_min;
        a_3(sample) = a;
        b_3(sample) = b;
        % Vehicle 4 Decelerates
        Vehicle = 4;
        Ustart  = u0;
        Uend    = u0;
        cT_AccelParam(Tstart,Tend,Ustart,Uend,Xstart4,Xend4);
        load('cT_ab.mat')
        a        = ab(1);
        b        = ab(2);
        Atab     = [Atab;a];
        Btab     = [Btab;b];
        F4       = @(t,X) a  -  b * t;
        G4       = @(t,X) sigma;
        obj_U4   = sde(F4, G4,'StartState',u0);
        [S_U4,T] = simulate(obj_U4, n, 'DeltaTime', Ts, 'nTrials', 1);
        F4 = @(t,X) Ustart + a*t - 0.5*b*t^2;
        G4 = @(t,X) sigma;
        obj_X4   = sde(F4, G4,'StartState',Xstart4);
        [S_X4,T] = simulate(obj_X4, n, 'DeltaTime', Ts, 'nTrials', 1);
        U_min    = min(S_U4);
        % crash probability
        if U_min <= 0
          nbrkdn4 = nbrkdn4 + 1;
        end
        u_4(sample) = U_min;
        a_4(sample) = a;
        b_4(sample) = b;

        % Vehicle 1
        pbrkdn1  = nbrkdn1/N;
        u_1_mean = mean(u_1);
        a_1_mean = mean(a_1);
        b_1_mean = mean(b_1);
        % Vehicle 2
        pbrkdn2  = nbrkdn2/N;
        u_2_mean = mean(u_2);
        a_2_mean = mean(a_2);
        b_2_mean = mean(b_2);
        % Vehicle 3
        pbrkdn3  = nbrkdn3/N;
        u_3_mean = mean(u_3);
        a_3_mean = mean(a_3);
        b_3_mean = mean(b_3);
        % Vehicle 4
        pbrkdn4  = nbrkdn4/N;
        u_4_mean = mean(u_4);
        a_4_mean = mean(a_4);
        b_4_mean = mean(b_4);
        % Make Summary Table British Units
        vehicle    = [1;2;3;4];
        u_min      = [u_1_mean;u_2_mean;u_3_mean;u_4_mean];
        pbrkdn     = [pbrkdn1;pbrkdn2;pbrkdn3;pbrkdn4];
        a_mean     = [a_1_mean; a_2_mean; a_3_mean; a_4_mean];
        b_mean     = [b_1_mean; b_2_mean; b_3_mean; b_4_mean];
        ssafe      = [trial; trial; trial; trial];
        % Make Summary Table SI
        u_min_mean = 0.3048*u_min;
        if run == 1 & sample == 100 
            str    = 'ZipperStats.mat';
            Zipper = [T,S_U1,S_U2,S_U3,S_U4,S_X1,S_X2,S_X3,S_X4];
            save('Zipper.mat')
            table(vehicle,pbrkdn,a_mean,b_mean,u_min_mean,ssafe)
            save('ZipperStats.mat','vehicle','pbrkdn','a_mean','b_mean','u_min_mean','ssafe')
        end
        if run == 2 & sample == 100 
            str = 'SBS_Stats.mat';
            SBS = [T,S_U1,S_U2,S_U3,S_U4,S_X1,S_X2,S_X3,S_X4];
            table(vehicle,pbrkdn,a_mean,b_mean,u_min_mean,ssafe)
            save('SBS_Stats.mat','vehicle','pbrkdn','a_mean','b_mean','u_min_mean','ssafe')
        end
    end
    
end



% SI plots
load('Zipper.mat')
Tend = max(T);
figure('Name','SDE')
subplot(2,2,1)
plot(T, 0.3048*S_U1,'LineWidth',2)
hold on
plot(T, 0.3048*S_U2,'LineWidth',2)
hold on
plot(T, 0.3048*S_U3,'LineWidth',2)
hold on
plot(T, 0.3048*S_U4,'LineWidth',2)
hold on
plot(t,y00,'k-')
axis([0 Tend 0.3048*60 0.3048*90]);
xlabel(str1,'Interpreter','latex');
ylabel(str3,'Interpreter','latex');		
title('Zipper Merge');
legend('Vehicle 1','Vehicle 2','Vehicle 3','Vehicle 4','Location','southwest')

subplot(2,2,3)
plot(T, 0.3048*S_X1,'LineWidth',2)
hold on
plot(T, 0.3048*S_X2,'LineWidth',2)
hold on
plot(T, 0.3048*S_X3,'LineWidth',2)
hold on
plot(T, 0.3048*S_X4,'LineWidth',2)
hold on
plot(t,y00,'k-')
axis([0 Tend -0.3048*400 0.3048*500]);
xlabel(str1,'Interpreter','latex');
ylabel(str2,'Interpreter','latex');
title('Zipper Merge');
legend('Vehicle 1','Vehicle 2','Vehicle 3','Vehicle 4','Location','southeast')

load('SBS.mat')
subplot(2,2,2)
plot(T, 0.3048*S_U1,'LineWidth',2)
hold on
plot(T, 0.3048*S_U2,'LineWidth',2)
hold on
plot(T, 0.3048*S_U3,'LineWidth',2)
hold on
plot(T, 0.3048*S_U4,'LineWidth',2)
hold on
plot(t,y00,'k-')
axis([0 Tend -0.3048*100 0.3048*100]);
xlabel(str1,'Interpreter','latex');
ylabel(str3,'Interpreter','latex');	
title('Side-by-Side Merge');
legend('Vehicle 1','Vehicle 2','Vehicle 3','Vehicle 4','Location','southwest')

subplot(2,2,4)
plot(T, 0.3048*S_X1,'LineWidth',2)
hold on
plot(T, 0.3048*S_X2,'LineWidth',2)
hold on
plot(T, 0.3048*S_X3,'LineWidth',2)
hold on
plot(T, 0.3048*S_X4,'LineWidth',2)
hold on
plot(t,y00,'k-')
axis([0 Tend -0.3048*175 0.3048*500]);
xlabel(str1,'Interpreter','latex');
ylabel(str2,'Interpreter','latex');
title('Side-by-Side Merge');
legend('Vehicle 1','Vehicle 2','Vehicle 3','Vehicle 4','Location','northwest')

x0=10;
y0=10;
width=550;
height=700;
set(gcf,'position',[x0,y0,width,height])

saveas(gcf,'Figure4.pdf')

  



