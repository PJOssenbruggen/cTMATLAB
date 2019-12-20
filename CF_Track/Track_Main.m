clear all
close all
clear global
clc
% Model specification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R    = 500.;  % turn radius in feet
u    = 77.7;  % feet/sec (vehicle speed 53 mph)
rw   = 12;    % rw = roadwidth = 12 feet
Rl   = R - rw/2;
Rf   = R + rw/2;
N_v  = 2;   % N_V = number of vehicles in the bottleneck merge.
N_Ts = 61;  % N_Ts = number of 1 second time-steps.
Ts   = 1;
t    = 0:Ts:N_Ts;
t    = t';
l    = 14;
s    = 5*l;   % Safe headway
theta = zeros(N_Ts,1);
rad  = zeros(N_Ts,1);
Xl   = zeros(N_Ts,1); 
Yl   = zeros(N_Ts,1);
Xf   = zeros(N_Ts,1); 
Yf   = zeros(N_Ts,1);
Ul   = u*ones(N_Ts,1); 
Uf   = u*ones(N_Ts,1);

% Track Geometry %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Labels();
load('cT_Setup.mat')
i1 = 1;
i2 = 11;
for i = i1:i2
    theta(i)     = 180 + 9*t(i);     % theta = 9 degrees per second (assumed)
    rad(i)       = theta(i)*pi/180;  % rad = 0.1571 radians per second
    % centifugal acceleration a = u*u/R (12 ft per second squared)
    Xl(i)        = R * (1 + cos(rad(i)));
    Yl(i)        = R * sin(rad(i));
    Xf(i)        = Xl(i);
    Yf(i)        = Yl(i);
end
i3 = 12;
i4 = 21;
for i = i3:i4
    theta(i)     = 270;
    rad(i)       = theta(i)*pi/180;
    Xl(i)        = R + u*(t(i)-10);
    Yl(i)        = -R - (Rl - R)*(t(i) - 10)/10;
    Xf(i)        = Xl(i);
    Yf(i)        = -R - (Rf - R)*(t(i) - 10)/10;
end
i5 = 22;
i6 = 31;
for i = i5:i6
    theta(i)     = 270 + 9*(t(i)-20);
    rad(i)       = theta(i)*pi/180;
    Xl(i)        = R + u*10 + Rl*cos(rad(i));
    Yl(i)        = Rl * sin(rad(i));
    Xf(i)        = R + u*10 + Rf*cos(rad(i));
    Yf(i)        = Rf * sin(rad(i));
end
i7 = 31;
i8 = 41;
for i = i7:i8
    theta(i)     = 9*(t(i)-30);
    rad(i)       = theta(i)*pi/180;
    Xl(i)        = R + u*10 + Rl*cos(rad(i));
    Yl(i)        = Rl * sin(rad(i));
    Xf(i)        = R + u*10 + Rf*cos(rad(i));
    Yf(i)        = Rf * sin(rad(i));
end
i9  = 42;
i10 = 51;
for i = i9:i10
    theta(i)     = 90;
    rad(i)       = theta(i)*pi/180;
    Xl(i)        = R + u*10 - u*(t(i)-40);
    Yl(i)        = Rl + (R - Rl)*(t(i)-40)/10;
    Xf(i)        = R + u*10 - u*(t(i)-40);
    Yf(i)        = Rf + (R - Rf)*(t(i)-40)/10;
end
i11 = 52;
i12 = 60;
for i = i11:i12
    theta(i)     = 90 + 9*(t(i)-50);
    rad(i)       = theta(i)*pi/180;
    Xl(i)        = R + R*cos(rad(i));
    Yl(i)        = R*sin(rad(i));
    Xf(i)        = R + R*cos(rad(i));
    Yf(i)        = R*sin(rad(i));
end
t   = 0:60;
t   = t';
xy  = [60 0 0 0 0 0 0];
XY  = [t theta rad Xl Yl Xf Yf];
XY  = [XY; xy];


% Speed and Travel Distance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_Ts = 70;
Ts   = 1;
t    = 0:Ts:N_Ts;
t    = t';
tL   = 10;
tC   = 20;
L    = u*tL;  % Merge zone (feet)
J    = 4;     % J = zone number
v    = 0;
% Leading vehicle
Ustart = u;
Uend   = u;
for v = 0:9
    if v == 0 || v == 2 || v == 4 || v == 6 || v == 8
        % Criuse Zone 1
        Distance = R * pi;     % On Curve
        N1       = 20;
        t1       = R*pi/N1/u;  % vehicle step-time
        Zone     = 1;
        Tstart   = 0;
        if v == 0 || v == 2 || v == 4 || v == 6 || v == 8
            Tend     = N1*t1 + v*s/u;
            Xstart   = -s*v;
            Xend     = Distance;
        end   
        Tl       = table(Zone,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        cT_AccelParam2(Tstart,Tend,Ustart,Uend,Xstart,Xend);
        load('cT_ab.mat')
        a        = ab(1);
        b        = ab(2);
        Zl = Speed_Location(a,b,Ts,Tstart,Tend,Ustart,Uend,Xstart,Xend);      
        %  Diverge Zone   
        N2       = 10;
        t2       = L/u/N2;
        Zone     = 2;
        Tstart   = Tl.Tend;
        Tend     = Tstart + N2*t2;
        Distance = L;  % On Straight
        Xstart   = Tl.Xend;
        Xend     = Xstart + Distance;
        Tmpl     = table(Zone,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        Tl       = [Tl; Tmpl];  
        cT_AccelParam2(Tstart,Tend,Ustart,Uend,Xstart,Xend);
        load('cT_ab.mat')
        a        = ab(1);
        b        = ab(2);
        Z2 = Speed_Location(a,b,Ts,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        Zl = [Zl; Z2];
        % Cruise Zone 2   
        N3       = 20;
        t3       = Rl*pi/N3/u;
        Zone     = 3;
        Tstart   = Tl.Tend(2);
        Tend     = Tstart + N3*t3;
        Distance = Rl*pi;    % On Curve
        Xstart   = Tl.Xend(2);
        Xend     = Xstart + Distance;
        Tmpl     = table(Zone,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        Tl       = [Tl; Tmpl]; 
        cT_AccelParam2(Tstart,Tend,Ustart,Uend,Xstart,Xend)
        load('cT_ab.mat')
        a       = ab(1);
        b       = ab(2);
        Z3      = Speed_Location(a,b,Ts,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        Zl      = [Zl; Z3];
        % Merge Zone     
        N4       = 10;
        t4       = L/u/N4;
        Zone     = 4;
        Tstart   = Tl.Tend(3);
        Tend     = Tstart + N4*t4;
        Distance = L + 2.5*l;       % On straight
        Xstart   = Tl.Xend(3);
        Xend     = Distance + Xstart;
        Tmpl     = table(Zone,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        Tl       = [Tl; Tmpl];  
        cT_AccelParam2(Tstart,Tend,Ustart,Uend,Xstart,Xend)
        load('cT_ab.mat')
        a       = ab(1);
        b       = ab(2);
        Z4      = Speed_Location(a,b,Ts,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        Zl      = [Zl; Z4];
        % Cruise Zone 1
        Zone     = 5;
        Tstart   = Tl.Tend(4);
        Tend     = Tstart + 10;
        Distance = 10*u;       % On straight
        Xstart   = Tl.Xend(4);
        Xend     = Distance + Xstart;
        Tmpl     = table(Zone,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        Tl       = [Tl; Tmpl];  
        cT_AccelParam2(Tstart,Tend,Ustart,Uend,Xstart,Xend)
        load('cT_ab.mat')
        a       = ab(1);
        b       = ab(2);
        Z5      = Speed_Location(a,b,Ts,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        Zl      = [Zl; Z5]; 
        if v == 0
            Zl0 = Zl;
        else
            nz  = size(Zl0);
            nz  = nz(1);
            Zl  = Zl(1:nz,:);
            Zl0 = [Zl0 Zl];
        end
    else
        % Following vehicle
        % Cruise Zone 1
        N1       = 20;
        t1       = R*pi/N1/u;
        Zone     = 1;
        Tstart   = 0;
        Tend     = Tl.Tend(1);
        Xstart   = -s*v;
        if v == 1 || v == 3 || v == 5 || v == 7 || v == 9
            Tend     = N1*t1 + (v-1)*s/u;
            Xstart   = -s*v;
            Xend     = Distance;
        end 
        Distance = u*Tend;   % On Curve
        Xend     = Xstart + Distance; 
        Tf       = table(Zone,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        cT_AccelParam2(Tstart,Tend,Ustart,Uend,Xstart,Xend);
        load('cT_ab.mat')
        a        = ab(1);
        b        = ab(2);
        Zf       = Speed_Location(a,b,Ts,Tstart,Tend,Ustart,Uend,Xstart,Xend);   
        % Diverge Zone   
        N2       = 30;
        Zone     = 2;
        Tstart   = Tl.Tstart(2);
        Tend     = Tl.Tend(3);
        Distance = L + Rf*pi + s*v;
        Xstart   = Tf.Xend(1);
        Xend     = Tl.Xend(3);
        Tmpf     = table(Zone,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        Tf       = [Tf; Tmpf];  
        cT_AccelParam2(Tstart,Tend,Ustart,Uend,Xstart,Xend);
        load('cT_ab.mat')
        a        = ab(1);
        b        = ab(2);
        Z2       = Speed_Location(a,b,Ts,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        Zf       = [Zf; Z2];
        % Merge Zone    
        N3       = 10;
        Zone     = 3;
        Tstart   = Tl.Tstart(4);
        Tend     = Tl.Tend(4);
        Distance = L - 2.5*l;
        Xstart   = Tf.Xend(2);
        Xend     = Distance + Xstart;
        Tmpl     = table(Zone,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        Tf       = [Tf; Tmpl];  
        cT_AccelParam2(Tstart,Tend,Ustart,Uend,Xstart,Xend)
        load('cT_ab.mat')
        a        = ab(1);
        b        = ab(2);
        Z4       = Speed_Location(a,b,Ts,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        Zf       = [Zf; Z4];
        % Cruise Zone 1
        Zone     = 4;
        Tstart   = Tl.Tend(4);
        Tend     = Tstart + 10;
        Distance = 10*u;       % On straight
        Xstart   = Tf.Xend(3);
        Xend     = Distance + Xstart;
        Tmpl     = table(Zone,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        Tl       = [Tl; Tmpl];  
        cT_AccelParam2(Tstart,Tend,Ustart,Uend,Xstart,Xend)
        load('cT_ab.mat')
        a       = ab(1);
        b       = ab(2);
        Z4      = Speed_Location(a,b,Ts,Tstart,Tend,Ustart,Uend,Xstart,Xend);
        Zf      = [Zf; Z4];
        if v == 1
            Zf0 = Zf;
        else
            nz  = size(Zf0);
            nz  = nz(1);
            Zf  = Zf(1:nz,:);
            Zf0 = [Zf0 Zf];
        end
    end 
end
Plot1(XY)
Plot2(Zl0, Zf0)
Plot3(XY)
Plot4(Zl0, Zf0)


