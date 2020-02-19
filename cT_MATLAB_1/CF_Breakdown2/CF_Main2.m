cd '/Users/PJO/Desktop/cT_MATLAB/CF_Breakdown2'
addpath('/Users/PJO/Desktop/cT_MATLAB/CF_Breakdown2')
clear all
close all
clear global
clc
global U X Unew Xnew;
nTrials = 20;
seed    = 137;
sigma_u0_ratio = 0.03;
Input   = table(seed, sigma_u0_ratio, nTrials)
% Define model parameters and axis labels.
Step12(nTrials, seed, sigma_u0_ratio)
load('cT_Setup.mat')
% Plot 

% Simulate nTrials of U and X, unassisted drivers.
Step22(nTrials);
label1 = 'Figure12.pdf';
label2 = 'Figure22.pdf';
label3 = 'Figure32.pdf';
label4 = 'Figure42.pdf';
label5 = 'Figure52.pdf';
label6 = 'Figure62.pdf';
% Figure 1
Plot12(nTrials,label3);

% A Car-following algorithm.
% Returns: Unew and Xnew. 
% Car-following calls Step4, which finds Nviol, violations of safe headway. 
% Step4 returns: Tlf, Tab, Nviol.
% Step5 finds Unew and Xnew for Nviol
Tabab = Step32;

% Plot 
Plot22(nTrials,label2);
if sigma_u0_ratio > 0
    Plot32(label1,Tabab);
end
% Car-following Performance at time t = 10, 30 and 60 seconds.
Step62

% Kalman Filter
xstart = 0:s:nTrials*s;
for i = 1:nTrials
    Z  = Step102(xstart(i));
    if i == 1
        ZZ = Z;
        Z1 = Z;
    else
        ZZ = [ZZ Z];
    end
end
Plot42(Z1,label4);
Plot52(ZZ,label5)

xstart = 0.5*xstart;
for i = 1:nTrials
    Z  = Step102(xstart(i));
    if i == 1
        ZX = Z;
        Z1 = Z;
    else
        ZX = [ZX Z];
    end
end
Plot52(ZX,label5)

Plot62(ZZ,ZX,label6)