function cT_AccelParam(Tstart,Tend,Ustart,Uend,Xstart,Xend)
% Find a and b
Dt = Tend - Tstart;
Du = Uend - Ustart;
Dx = Xend - Xstart - Ustart*Dt;
A  = [Dt -0.5*Dt^2; 0.5*Dt^2 -Dt^3/6];
B  = [Du; Dx];
ab = A^-1*B;
save cT_ab.mat;
end
