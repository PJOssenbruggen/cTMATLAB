function ab = Step64(Tstart,Tend,Ustart,Uend,Xstart,Xend)
% "Step 6: Following vehicle alters trajectory"
% Find a and b
Dt = Tend - Tstart;
Du = Uend - Ustart;
Dx = Xend - Xstart - Ustart*Dt;
A  = [Dt -0.5*Dt^2; 0.5*Dt^2 -Dt^3/6];
B  = [Du; Dx];
ab = A^-1*B;
%Step64_1 = table(Tstart,Tend,Ustart,Uend,Xstart,Xend)
%b = ab(2);
%Step64_2 = table(Dt,Du,Dx, a, b)
end
    