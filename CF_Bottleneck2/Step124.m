function Ustar = Step124(Tstart,Tend,Ustart,Uend,Xstart,Xend,Ts)
    ab       = Step64(Tstart,Tend,Ustart,Uend,Xstart,Xend);
    a        = ab(1);
    b        = ab(2);
    t2       = Tstart:Ts:Tend;
    n2       = size(t2,2);
    u        = zeros(n2,1);
    u0       = Ustart;
  %  x0       = Xstart;
    for i = 1:n2
   %    acc(i) = a - b*(t2(i) - Tstart);
        u(i) = u0 + a*(t2(i) - Tstart) - 0.5*b*(t2(i) - Tstart)^2;
   %    x(i) = x0 + u0*(t2(i) - Tstart) + 0.5*a*(t2(i) - Tstart)^2 - b/6*(t2(i) - Tstart)^3; 
    end
    Ustar = u;
end