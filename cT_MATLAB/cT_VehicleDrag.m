clear all, close all, clc
% https://en.wikipedia.org/wiki/Automobile_drag_coefficient
g    = 32.2; % gravity fps
u    = 53;   % target speed
mpsu = u/(0.62137 * 3.6);
W    = 4000; % vehicle weight in pounds
M    = W/g;  % U.S. units (slugs)
mps  = u / (0.62137 * 3.6); % u in mph and mps in meter per section
cd   = 0.3;  % average passenger vehicle
rho  = 1.2;  % kg per m^3
a    = 2;    % m^2 frontal area
fN   = 0.5 * cd * rho * mps ^2 * 2; % drag force in Newtons
Fd   = fN * 3.37/0.453; % drag force in pounds
mph  = 0:0.01:100;  
mps  = mph/(0.62137 * 3.6); % mpsu is a vector
for k = 1:length(mph)
    N(k) = 0.5 * cd * rho * mps(k) ^2 * 2;
end
% First-order Tayler series of drag
C0   = 0.5 * cd * rho * a; % unit kg/m^2
C1   = 2*C0*mpsu;
% Nlin = linear equation in Newtons
for k = 1:length(mph)
   intercept(k) = fN;
   Nlin(k) = fN + C1 * (mps(k) - mpsu);
end

subplot(3,1,1)
plot(mps, N,'b-', mps, Nlin,'r-', mps,intercept,'k--')
ylabel('Fd, Newtons')
xlabel('Speed, meters per second')
legend('Drag force.')
hold on
x = [mpsu mpsu];
y = [-fN 3*fN];
plot(x,y,'k--')
title('Drag force.')
hold off
%% 
hold on
plot(mpsu, fN, 'bo')
subplot(3,1,2)
D0 = C0 * 3.37/0.453;
D1 = C1 * 3.37/0.453; % Slope of drag curve
plot(mph, N * 3.37/0.453,'b-', mph, Nlin * 3.37/0.453, 'r-',mph, intercept* 3.37/0.453,'k--')
ylabel('Fd, pounds')
xlabel('Speed, mph')
hold on
plot(u, Fd, 'bo')
hold on
v0 = [mpsu mpsu]*(0.62137 * 3.6);
y1 = [-fN 3*fN]* 3.37/0.453;
plot(v0,y1,'k--')
legend('Drag Force')
hold off

subplot(3,1,3)
b = D1;
m = M;
v0 = v0(1)
dt = 0.001;
Fd = y1(1);
t  = 0:dt:6;
for k = 1:length(t)
    v(k) = exp(-b*t(k)/m)*(Fd*t(k)/m + v0);
end

plot(t,v)
title('Open-loop Control')
xlabel('Time, seconds')
ylabel('Speed, mph')
legend('Driver provides no acceleration.')



