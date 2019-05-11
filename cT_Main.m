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
    Ra = 10^0;
    cT_Feedback(Qa,Ra);
% Step 2. Study the affects Traffic volatity. Figure 2 %%%%%%%%%%%%%%%%%%%%
    nTrials = 4;
    Vfps    = [85; 70; 80; 65]; % Vehicle speeds in feet per second
    sigma   = [4; 2; 3; 1]; % Vehicle speed volatility
 % Vehicle speed volatility
    Trial_Table = [Vfps, sigma];
    save cT_Trial_Table.mat
    [X0,U0,Sigma] = cT_U0(nTrials,Vfps,sigma);
% Make a y_cld matrix  
    cT_SDE(nTrials,X0,Vfps,sigma);
% Step 3. Study Headways Figure 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for Lead = 1:nTrials-1
        if Lead == 1
            save Lead.mat
        end
        cT_CarFollowing(Lead);   
    end
    cT_Headways
    
% Step 5. Kalman Filter
    Q  = 625;  % Disturbance
    R  = 1;    % Noise Variance
    cT_KalmanFilter(Q,R)
    