cd '/Users/PJO/Desktop/cT_MATLAB/CF_Bottleneck2'
addpath('/Users/PJO/Desktop/cT_MATLAB/CF_Bottleneck2')
clear all
close all
clear global
clc
global Uleft Xleft Uright Xright UleftNew XleftNew UrightNew XrightNew;
nTrials = 10;
sigma_u0_ratio = 0.0;
Sigma_u0_ratio = table(sigma_u0_ratio);
nTrialsLeft    = nTrials;
nTrialsRight   = nTrials;
Input          = table(sigma_u0_ratio, nTrialsLeft, nTrialsRight)
% Define model parameters and axis labels.
nr = Step14(nTrials, sigma_u0_ratio);
load('cT_Setup.mat')
% The following labels specify the Figure numbers for EXPLAINING AND PREVENTING DELAY AT A BOTTLENECK
label1 = 'Figure1.pdf';
label2 = 'Figure2.pdf';
label3 = 'Figure3.pdf';
label4 = 'Figure4.pdf';
label5 = 'Figure5.pdf';
label6 = 'Figure6.pdf';
label7 = 'Figure7.pdf';
label8 = 'Figure8.pdf';
% A Car-following algorithm.
seed             = 135;
[Uleft, Xleft]   = Step24(nTrials, seed);
[UleftNew, XleftNew, leftTabab] = Step34(Uleft,Xleft);
leftTabab
% Simulate nTrials of U and X, unassisted drivers.
seed             = 123;
[Uright, Xright] = Step24(nTrials, seed);
[UrightNew, XrightNew, rightTabab] = Step34(Uright,Xright);
rightTabab
%Plot1(nTrials,Uleft,Xleft, Uright,Xright,label1);
%Plot2(nTrials, UleftNew, XleftNew, UrightNew, XrightNew, label2);
% Delay at bottleneck
[U,X,newTrials] = Step74(UleftNew, XleftNew, UrightNew, XrightNew, nTrials);
[Unew, Xnew]    = Step84(U, X, newTrials);
nOpt = 20;
for i = 1:nOpt
    [Unew, Xnew, Vehicle, Delay, Performance] = Step84(Unew, Xnew, newTrials);
    if i == nOpt
        Vehicle
        Delay
        Performance
    end
end
%Plot3(U, X, Unew, Xnew, newTrials,label3);
[Unew, Xnew] = Step94(Unew, Xnew, newTrials, Vehicle);
Plot4(Unew, Xnew, newTrials, label5, Performance);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nTrials = 10;
sigma_u0_ratio = 0.03;
Sigma_u0_ratio = table(sigma_u0_ratio);
nTrialsLeft    = nTrials;
nTrialsRight   = nTrials;
Input          = table(sigma_u0_ratio, nTrialsLeft, nTrialsRight)
% Define model parameters and axis labels.
nr = Step14(nTrials, sigma_u0_ratio);
load('cT_Setup.mat')
% The following labels specify the Figure numbers for EXPLAINING AND PREVENTING DELAY AT A BOTTLENECK
% A Car-following algorithm.
seed             = 135;
[Uleft, Xleft]   = Step24(nTrials, seed);
[UleftNew, XleftNew, leftTabab] = Step34(Uleft,Xleft);
leftTabab
% Simulate nTrials of U and X, unassisted drivers.
seed             = 123;
[Uright, Xright] = Step24(nTrials, seed);
[UrightNew, XrightNew, rightTabab] = Step34(Uright,Xright);
rightTabab
Plot1(nTrials,Uleft,Xleft, Uright,Xright,label1);
Plot2(nTrials, UleftNew, XleftNew, UrightNew, XrightNew, label2);
% Delay at bottleneck
[U,X,newTrials] = Step74(UleftNew, XleftNew, UrightNew, XrightNew, nTrials);
[Unew, Xnew]    = Step84(U, X, newTrials);
nOpt = 20;
for i = 1:nOpt
    [Unew, Xnew, Vehicle, Delay, Performance] = Step84(Unew, Xnew, newTrials);
    if i == nOpt
        Vehicle
        Delay
        Performance
    end
end
Plot3(U, X, Unew, Xnew, newTrials,label3);
[Unew, Xnew] = Step94(Unew, Xnew, newTrials, Vehicle);
Plot4(Unew, Xnew, newTrials, label4, Performance);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kalman Filter
[D1 D2 sys u_star] = Step104;
Plot5(D1,D2,label7)

% Kalman Filter
[KF Performance] = Step144(sys,u_star);
Plot6(KF, label6)
Performance

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comparison deterministic and stochastic models

sig = [0, 0.01, 0.02, 0.03, 0.04, 0.05];
for run = 1:6
    nTrials = 10;
    sigma_u0_ratio   = sig(run);
    Sigma_u0_ratio   = [Sigma_u0_ratio; table(sigma_u0_ratio)];
    nTrialsLeft      = nTrials;
    nTrialsRight     = nTrials;
    seed             = 135;
    nr               = Step14(nTrials, sigma_u0_ratio);
    [Uleft, Xleft]   = Step24(nTrials, seed);
    [UleftNew, XleftNew, Tabab] = Step34(Uleft,Xleft);
    % Simulate nTrials of U and X, unassisted drivers.
    seed   = 123;
    [Uright, Xright] = Step24(nTrials, seed);
    [UrightNew, XrightNew, Tabab] = Step34(Uright,Xright);
    % Delay at bottleneck
    [U,X,newTrials]  = Step74(UleftNew, XleftNew, UrightNew, XrightNew, nTrials);
    [Unew, Xnew]     = Step84(U, X, newTrials);
    nOpt = 20;
    for i = 1:nOpt
        [Unew, Xnew, Vehicle,Delay,Performance] = Step84(Unew, Xnew, newTrials);
    end
    [Unew1, Xnew1] = Step94(Unew, Xnew, newTrials, Vehicle);
    tripspd = mean(mean(Unew1))*0.3084;
    hdwymn  = Performance.Meanheadway*0.3084;
    spd42   = Performance.Meanspeed*0.3084;
    Vcnt    = Performance.SizeAcc;
    flow    = Performance.Estflow;
    decel   = Performance.MeanAcc*0.3084;
    speedmn = table(sigma_u0_ratio, tripspd,spd42, hdwymn, Vcnt, flow, decel);
    if run == 1
        PerformSum = speedmn;  
    else
        PerformSum = [PerformSum; speedmn];
    end
end
PerformSum


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


