function Z = Speed_Location(a,b,Ts,Tstart,Tend,Ustart,Xstart)
    if Tstart == 0
        t  = Tstart:Ts:Tend;
    else
        t1 = Tstart + Ts;
        t  = t1:Ts:Tend;
    end
    
    N      = size(t);
    N      = N(2);
    T      = zeros(N,1);
    speed  = zeros(N,1);
    loc    = zeros(N,1);
    for i = 1:N
        T(i) = t(i);
        speed(i) = Ustart + a*(t(i) - Tstart) - 1/2*b*(t(i) - Tstart)^2;
        loc(i) = Xstart + Ustart*(t(i) - Tstart) + 1/2*a*(t(i) - Tstart)^2 -1/6*b*(t(i) - Tstart)^3;
    end
    Z = [T speed loc];
end