% Specify problem parameters
    g  = 32.174;        % gravity constant
    W  = 4000;          % weight of a passenger vehicle    
    m  = W/g;           % vehicle mass
    Fd = 212*0.225;     % drag force in pounds. See VehicleDrag.m
    u0 = 5280/3600*53;  % target speed u0 = 77.7 fps = 53 mph
    b  = Fd/u0;         % slope of linear drag force curve
    l  = 14;            % Vehicle length, feet
    dt = 0.1;           % Time step, second
    Ts = dt;
    Tf = 60;            % Finish time, seconds 
    t  = 0:dt:Tf;
    t  = t';
    n  = size(t,1);
% Plot labels
    str1  = '$$ \textrm{Time }t \textrm{ } (s) $$';
    str2  = '$$ \textrm{Distance }x \textrm{ } (km)$$';
    str3  = '$$ \textrm{Speed }\dot{x} \textrm{ } (m/s) $$';
    str4  = '$$ \textrm{Headway }s \textrm{ } (m)$$';
    str5  = '$$ \textrm{Frequency }$$';
    str6  = '$$ \textrm{Flow }\bar{q} \textrm{ } (v/h) $$';
    str7  = '$$ \textrm{Headway }h \textrm{, feet} $$';
    str8  = '$$ \textrm{Density }k \textrm{ } (v/km) $$';
    str9  = '$$ \textrm{Speed }\bar{u} \textrm{ } (km/h) $$';
    str10 = '$$ \textrm{Density }\bar{k} \textrm{ } (v/km) $$';
    str11 = '$$ \kappa \textrm{ } (s) $$';
    str12 = '$$ \textrm{Force }f_d \textrm{ } (N) $$';
   
    save cT_Setup.mat 