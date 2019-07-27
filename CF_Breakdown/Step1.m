function Step1(nTrials, seed)
% Specify problem parameters
    g  = 32.174;        % gravity constant
    W  = 4000;          % weight of a passenger vehicle    
    m  = W/g;           % vehicle mass
    Fd = 202;           % drag force in pounds. See VehicleDrag.m
    u0 = 5280/3600*53;  % target speed u0 = 77.7 fps = 53 mph
    b  = 1.6167;        % slope of linear drag force curve
    l  = 14;            % Vehicle length, feet
    dt = 0.1;           % Time step, second
    Ts = dt;
    Tf = 60;            % Finish time, seconds 
    T_setup = table(g,W,m,Fd,u0,b,l);
    %T_setup
    tr  = 0:dt:Tf;
    Tr  = tr';
    nr  = size(Tr,1);
    s   = 5280/45;       % Capacity space headway
    b0  = zeros(nTrials,1);
    Sigma   = 0.01*u0;
% Plot labels
    str1  = '$$ \textrm{Time }t \textrm{ } (s) $$';
    str2  = '$$ \textrm{Distance }x \textrm{ } (m)$$';
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
    str13 = '$$ \textrm{Speed }\bar{u} \textrm{ } (mph) $$';
    str14 = '$$ \textrm{Headway }\bar{s} \textrm{, feet} $$';
    str15 = '$$ \textrm{Density }\bar{k} \textrm{ } (vpm) $$';
    str16 = '$$ \textrm{Flow }\bar{q} \textrm{ } (vph) $$';
    str17 = '$$ \textrm{Distance }x \textrm{ } (feet)$$';
    str18 = '$$ \textrm{Speed }\dot{x} \textrm{ } (fps) $$';
    str19 = '$$ \textrm{Acceleration }\ddot{x} \textrm{ } (fps^2) $$';
    str20 = '$$ \textrm{Vehicle Gap }x_{leader} - x_{follower} - l_{vehicle} \textrm{ } (m) $$';
    str21 = '$$ \kappa \textrm{ } (sample) $$';
    str22 = '$$ \textrm{Error (fps)} $$';
    save cT_Setup.mat
end
 