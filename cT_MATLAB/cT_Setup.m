% Specify problem parameters
    g  = 32.174;        % gravity constant
    W  = 4000;          % weight of a passenger vehicle    
    m  = W/g;           % vehicle mass
    Fd = 1503;          % drag force in pounds. See VehicleDrag.m
    u0 = 5280/3600*53;  % target speed u0 = 77.7 fps = 53 mph
    b  = Fd/u0;         % slope of linear drag force curve
    u0 = 77.7;          % Target Speed, feet per second (fps)
    l  = 14;            % Vehicle length, feet
    dt = 0.1;           % Time step, second
    Ts = dt;
    Tf = 60;   % Finish time, seconds 
    t  = 0:dt:Tf;
    t  = t';
    n  = size(t,1);
% Plot labels
    str1 = '$$ t, \textrm{ seconds} $$';
    str2 = '$$ \textrm{Distance }x \textrm{, feet} $$';
    str3 = '$$ \textrm{Speed }\dot{x} \textrm{ (fps)} $$';
    str4 = '$$ \textrm{Headway }s \textrm{, feet} $$';
    str5 = '$$ \textrm{Frequency }$$';
    str6 = '$$ \textrm{Flow }q \textrm{, vph} $$';
    str7 = '$$ \textrm{Space headway }h \textrm{, feet} $$';
    str8 = '$$ \textrm{Density }k \textrm{, vpm} $$';
    save cT_Setup.mat 