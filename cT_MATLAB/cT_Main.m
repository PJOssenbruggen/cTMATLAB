close all
clear all
clear global
clc
cd /Users/PJO/Desktop/cT_MATLAB

% Step 1. Assign parameters for cTfeedback. Figure 1. %%%%%%%%%%%%%%%%%%%%%
    rng(223)  % Random number generator
    cT_Setup
% Qa and Ra assigned to achieve an acceleration rate of 10 fps^2  
    Qa = 10^0;
    Ra = 10^3;
    cT_Feedback(Qa,Ra);
% Step 2. Study the affects Traffic volatity. Figure 2 %%%%%%%%%%%%%%%%%%%%
    nTrials = 4;
    Vspeed  = [70; 85; 80; 65]; % Vehicle speeds
    sigma   = [2.5; 2; 3; 1]; % Vehicle speed volatility
    Trial_Table = [Vspeed, sigma];
    save cT_Trial_Table.mat
    [X0,U0,Sigma] = cT_U0(nTrials,Vspeed,sigma);
% Make a y_cld matrix  
    cT_SDE(nTrials,X0,Vspeed,sigma);
% Step 3. Study Headways Figure 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for Lead = 1:nTrials-1
        cT_CarFollowing(Lead);   
    end
    load('cT_CarFollowing.mat')
    
    cT_Headways(K_t)
    
% Step 5. Kalman Filter
    Q  = 625;   % 
    R  = 25;    % Noise Variance
    cT_KalmanFilter(Q,R)
    