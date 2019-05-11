clear all
close all
clc

cd /Users/PJO/Desktop/cT_MATLAB_SI
% https://en.wikipedia.org/wiki/Automobile_drag_coefficient
u    = 53;     % target speed
mpsu = u*1.6/3.600;   % m/s
cD   = 0.3;    % average passenger vehicle
rho  = 1.275;  % kg per m^3
a    = 2;      % m^2 frontal area
mps  = 0:0.01:50;  
for k = 1:length(mps)
    N(k) = 0.5 * cD * rho * mps(k)^2 * a;
end
% First-order Tayler series of drag
C0   = 0.5 * cD * rho * a; % unit kg/m^2
C1   = 2*C0*mpsu;
% Nlin = linear equation in Newtons
fN   = 0.5 * cD * rho * mpsu^2 * a; % drag force in Newtons at u = 53 mph
fD   = 0.2248*fN;
for k = 1:length(mps)
   intercept(k) = fN;
   Nlin(k) = fN + C1 * (mps(k) - mpsu);
end
T = table(u, mpsu, fN, fD)
    str3  = '$$ \textrm{Speed }\dot{x} \textrm{ } (m/s) $$';
    str12 = '$$ \textrm{Force }f_d \textrm{ } (N) $$';

figure('Name','VehicleDrag')

plot(mps, N,'b-')
xlabel(str3,'Interpreter','latex')
ylabel(str12,'Interpreter','latex')
hold on
plot(mps,Nlin,'k-')
title('Drag force.')
x = [mpsu mpsu];
y = [-400 1000];
plot(x,y,'k--');
hold on
x = [0 50];
y = [fN fN];
plot(x,y,'k--');

saveas(gcf,'Figure6.pdf')




