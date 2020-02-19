function Step62
% Estimate Car-following Performance
load('cT_Setup.mat')
global Unew Xnew;
Time          = [10; 30; 60];
k_vpm         = zeros(3,1);
u_mph         = zeros(3,1);
L             = s*(nTrials);     % Feet at t = 0
k_vpm(1)      = round((nTrials-1)*5280/((Xnew(100,nTrials)*-1+s)-(Xnew(100,1)*-1+s)),1);
k_vpm(2)      = round((nTrials-1)*5280/((Xnew(300,nTrials)*-1+s)-(Xnew(300,1)*-1+s)),1);
k_vpm(3)      = round((nTrials-1)*5280/((Xnew(601,nTrials)*-1+s)-(Xnew(601,1)*-1+s)),1);
u_mph(1)      = round(3600/5280*mean(Unew(100,:)),1);
u_mph(2)      = round(3600/5280*mean(Unew(300,:)),1);
u_mph(3)      = round(3600/5280*mean(Unew(601,:)),1);

for i = 1:3
    flowNew(i)= k_vpm(i)*u_mph(i);
end
q_USA         = round(flowNew');
k_vpkm        = round(k_vpm * 0.62137,1);
u_kmph        = round(u_mph * 1.609,1);
for i = 1:3
    q_metric(i)= k_vpkm(i)*u_kmph(i);
end
q_metric      = round(q_metric',0)
PerformTab    = table(Time, k_vpm, u_mph, q_USA, k_vpkm, u_kmph, q_metric)

k0_vpm        = 45;
u0_mph        = 53;
q0_vph        = u0_mph*k0_vpm;
k0_vpkm       = round(k0_vpm * 0.62137,1);
u0_kmph       = round(u0_mph * 1.609,1);
q0_metric     = round(k0_vpkm*u0_kmph,1);
sigma_fps     = round(Sigma,2);
CapacityTab1  = table(k0_vpm,  u0_mph,  q0_vph)
CapacityTab2  = table(k0_vpkm, u0_kmph, q0_metric)

end
