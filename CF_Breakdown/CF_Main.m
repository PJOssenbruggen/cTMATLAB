addpath('/Users/PJO/Desktop/cT_MATLAB/CF_Breakdown')
clear all
close all
clear global
clc
global U X Unew Xnew Sigma;
nTrials = 10;
seed    = 124;
% Step 1. Define model parameters and axis labels.
Step1(nTrials, seed)
load('cT_Setup.mat')
% Plot 

% Step 2. Simulate nTrials of U and X, unassisted drivers.
Step2(nTrials);
label = 'Figure1.pdf';
Plot1(nTrials,label);

% Step 3. A Car-following algorithm.
% Returns: Unew and Xnew. 
% Car-following calls Step4, which finds Nviol, violations of safe headway. 
% Step4 returns: Tlf, Tab, Nviol.
% Step5 finds Unew and Xnew for Nviol
Step3;

% Plot 
label = 'Figure2.pdf';
Plot2(nTrials,label);
  