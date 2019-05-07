clear all
close all
clc

% Input Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    g  = 32.174;        % gravity constant
    W  = 4000;          % weight of a passenger vehicle    
    m  = W/g;           % vehicle mass
    Fd = 1503;          % drag force in pounds. See VehicleDrag.m
    u0 = 5280/3600*53;  % target speed u0 = 77.7 fps = 53 mph
    b  = Fd/u0;         % slope of linear drag force curve
    Tf = 60;            % time range
    Ts = 0.1;           % time step
    dt = Ts;            % time step
    t  = 0:dt:Tf;       % time range
    t  = t';
    h  = 28;            % headway with one car length between lead and following vehicle.
    filename = 'cT_InputData.mat';
    save cT_InputData.mat