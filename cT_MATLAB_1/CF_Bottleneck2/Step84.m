function [Unew, Xnew, Vehicle, Delay, Performance] = Step84(U, X, newTrials)
    % " Step 8: Merge Zone"
    % Fix U and X where nViol > 0
    load('cT_Setup.mat')
    Unew   = U;
    Xnew   = X;
    t0     = 302;
    t2     = Tr(t0):Ts:Tr(421);
    index2 = t0:421;
    Tstart = Tr(t0);
    Tend   = Tr(421);
    Vcount = 0;
    lead   = 1;
    follow = 1;
    H      = 0;
    Hnew   = 0;
    unew   = U(421,1);
    u0     = U(421,1); 
    Vehicle  = table(lead, follow, Hnew, unew);
    for k  = 1:newTrials-1
        lead    = k;
        follow  = k+1;
        Ul = U(:,k);    % Lead vehicle vectors
        Xl = X(:,k);
        Uf = U(:,k+1);  % Following vehicle vectors
        Xf = X(:,k+1);
        % Data at time = 42 seconds
        H  = Xl(421) - Xf(421);
        if H >= s
            Hnew     = H;   % At t = 42
            u0       = Unew(421,follow);
            unew     = Unew(421,follow);
            Vel      = 0;
            vehicle  = table(lead, follow, Hnew, unew);
            Vehicle  = [Vehicle; vehicle];
        else
            Vcount = Vcount + 1;     % Headway violation
            if Vcount > 1
                t0 = 302;
                if min(Delay.VelMin) < 10
                    t0     = 162;
                end
            end
            Tstart = Tr(t0);
            Tend   = Tr(421);
            t2     = Tr(t0):Ts:Tr(421);
            n2     = size(t2,2);
            index2 = t0:421;
            Ustart = Uf(t0);
            Xstart = Xf(t0);
            Uend   = min(Ul(421), Uf(421));
            Xend   = Xl(421) - s;
            Xlead  = Xl(421);
            Xfollow= Xf(421);
            Hnew   = s;
            ab     = Step64(Tstart,Tend,Ustart,Uend,Xstart,Xend);
            a      = ab(1);
            b      = ab(2);
            F      = @(t,X) a - b * t;
            G      = @(t,X) Sigma;
            obj_U  = sde(F, G,'StartState',Ustart,'StartTime',Tstart);
            [U2,T] = simulate(obj_U, n2-1, 'DeltaTime', Ts);
            % Following vehicle cannot exceed the speed of its lead vehicle
            for i = 1:n2
                i2 = index2(i);
                if U2(i) > Ul(i2)
                    U2(i) = Ul(i2);
                end
            % Following vehicle speed >= 0
                if U2(i) < 0
                    U2(i) = 0;
                end
            end
            % Deterministic model
            acc   = zeros(n2,1);
            u     = zeros(n2,1);
            x     = zeros(n2,1);
            u0    = Ustart;
            x0    = Xstart;
            for i = 1:n2
                acc(i) = a - b*(t2(i) - Tstart);
                u(i) = u0 + a*(t2(i) - Tstart) - 0.5*b*(t2(i) - Tstart)^2;
                x(i) = x0 + u0*(t2(i) - Tstart) + 0.5*a*(t2(i) - Tstart)^2 - b/6*(t2(i) - Tstart)^3; 
            end
            % Unew is a matrix and U2 is a vector that is stored in Unew. 
            Unew(index2,follow) = u;
            Xnew(index2,follow) = x;
            unew    = u(120);
            u0      = U(421,k);
            tm      = 0.5*n2;
            AccMin  = min(acc);
            VelMin  = min(u);
            vehicle = table(lead, follow, Hnew, unew);
            Vehicle = [Vehicle; vehicle];
            delay   = table(Vcount, H, lead, follow, Xlead, Xfollow, k, AccMin, VelMin);
            if Vcount == 1
                Delay = delay;
            else
                Delay = [Delay; delay];   
            end
        end 
    end 
    if Vcount > 0
        Delay;
    end
    % Performance at time = 42 seconds
    MeanAcc     = mean(Delay.AccMin);
    SizeAcc     = Vcount;
    Meanheadway = mean(Vehicle.Hnew);
    Meanspeed   = mean(Vehicle.unew);
    Estflow     = mean(Vehicle.unew)/mean(Vehicle.Hnew(2:6))*3600;
    Performance = table(Meanheadway, Meanspeed, SizeAcc, MeanAcc, Estflow);
    % Following vehicle cannot exceed the speed of its lead vehicle
end 

