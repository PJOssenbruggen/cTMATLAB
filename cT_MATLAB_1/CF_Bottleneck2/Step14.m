function nr = Step14(nTrials, sigma_u0_ratio)
    % "Step 1: Set up"
    % Specify problem parameters
    g  = 32.174;        % gravity constant
    W  = 4000;          % weight of a passenger vehicle    
    m  = W/g;           % vehicle mass
    Fd = 56.3;          % drag force in pounds. See VehicleDrag.m
    u0 = 5280/3600*53;  % target speed u0 = 77.7fps = 53mph
    b  = 21.1;          % slope of linear drag force curve pound-second per foot
    l  = 14;            % Vehicle length, feet
    dt = 0.1;           % Time step, second
    Ts = dt;
    Tf = 60;            % Finish time, seconds 
    tr = 0:dt:Tf;
    Tr = tr';
    nr = size(Tr,1);
    s  = 5280/45;       % space headway at t = 0
    b0 = zeros(nTrials,1);
    Sigma     = sigma_u0_ratio*u0;   % Feet
    T_setup   = table(g,W,m,Fd,u0,Sigma);
    u0_mps    = 0.3048*u0;
    Sigma_mps = 0.3048*Sigma;
    s_mps     = 0.3048*s;
    T_setup2  = table(u0_mps, Sigma_mps,b,l,s, s_mps);
% Plot labels
    str1  = '$$ \textrm{Time }t \textrm{ } (s) $$';
    str2  = '$$ \textrm{Location }\hat{x} \textrm{ } (m)$$';
    str3  = '$$ \textrm{Speed }\hat{\dot{x}} \textrm{ } (m/s) $$';
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
    str17 = '$$ \textrm{Location }x^* \textrm{ } (feet)$$';
    str18 = '$$ \textrm{Speed }\hat{\dot{x}} \textrm{ } (m/3) $$';
    str19 = '$$ \textrm{Acceleration }\ddot{x} \textrm{ } (fps^2) $$';
    str20 = '$$ \textrm{Vehicle Gap }x_{leader} - x_{follower} - l_{vehicle} \textrm{ } (m) $$';
    str21 = '$$ \kappa \textrm{ } (sample) $$';
    str22 = '$$ \textrm{Error }\epsilon \textrm{ } (m/s) $$';
    str23 = '$$ \textrm{Force }f_d \textrm{ } (Pound-force) $$';
    str24 = '$$ \textrm{Force }F \textrm{ } (Pound-force) $$';
    str25 = '$$ \textrm{Force }f_d \textrm{ } (Pound-force) $$';
    str26 = '$$ \textrm{Gap }s - l \textrm{ } (m) $$';
    str27 = '$$ \textrm{ }t_1^M $$';
    str28 = '$$ \textrm{ }t_1^B $$';
    str29 = '$$ \hat{\dot{x}}(t) \textrm{, Left-lane} $$';
    str30 = '$$ \hat{\dot{x}}(t) \textrm{, Right-lane} $$';
    str31 = '$$ w_r = u^*(t) $$';
    str32 = '$$ y_M(t)$$';
    str33 = '$$ y_F(t) $$';
    str34 = '$$ \epsilon_M(t) = y_M(t) - y(t) $$';
    str35 = '$$ \epsilon_F(t) = y_F(t) - y(t) $$';
    str36 = '$$ \textrm{ }t_1^C $$';
    str37 = '$$ \textrm{Leader } $$';
    str38 = '$$ \textrm{Follower } $$';
    str39 = '$$ \textrm{C }  $$';
    str40 = '$$ \textrm{M }  $$';
    str41 = '$$ \textrm{B }  $$';
    str42 = '$$ \textrm{ }t^C $$';
    str43 = '$$ \textrm{ }t^M $$';
    str44 = '$$ \textrm{ }t^B $$';
    save cT_Setup.mat
end
 