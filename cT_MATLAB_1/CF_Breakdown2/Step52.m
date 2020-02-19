function [Ucf Xcf, Tab3] = Step52(Ul,Xl,Uf,Xf,Tab1,Tab2)
    % Estimate new trajectories
    global U X Unew Xnew;
    load('cT_Setup.mat')
    Ulf = [Ul Uf];
    Xlf = [Xl Xf];
    % capacity headway
    for j = 1:2
        Tstart      = Tab1.Tstart;
        Tend        = Tab1.Tend;
        inds        = Tab2.nstart;
        inde        = Tab2.nend;
        Ustart      = Ulf(inds);     % following
        Uend        = Ulf(inde);     % lead = following
        Xstart      = Xlf(inds);     % following 
        Xend        = Xlf(inde) - s; % follow = lead - safe headway         
        % Phase 1 for the following vehicle
        t1          = 1:Tab2.nstart;
        U1          = Uf(t1);
        n1          = length(U1);
        % Phase 2  for the following vehicle
        Tab3     = table(Tstart,Tend,Ustart,Uend,Xstart,Xend);
        cT_AccelParam2(Tstart,Tend,Ustart,Uend,Xstart,Xend)
        load('cT_ab.mat')
        a        = ab(1);
        b        = ab(2);
        F        = @(t,X) a - b * t;
        G        = @(t,X) Sigma;
        obj_U    = sde(F, G,'StartState',Ustart,'StartTime',Tstart);
        t2       = Tab2.nstart:Tab2.nend;
        n2       = size(t2,2);
        [U2,T]   = simulate(obj_U, n2-1, 'DeltaTime', Ts);
        Tl = length(T);
        for i = 1:Tl
            i2 = t2(i);
            if U2(i) > Ul(i2)
                U2(i) = Ul(i2);
            end
        end 
        n2       = length(U2);
    end 
    n12 = n1+n2;
    if (n1 + n2 < nr)
    % Phase 3 for the following vehicle
        nend    = Tab2.nend+2;
        t3      = nend:1:nr;
        n3      = length(t3);
        X3      = zeros(n3,1);
        F1      = @(t,X) 0;
        G1      = @(t,X) Sigma;
        obj_U   = sde(F1, G1,'StartState',0);
        [U3,T]  = simulate(obj_U, n3-1, 'DeltaTime', Ts);
        Tl      = length(T);
        for i = 1:Tl
            i3 = t3(i);
            if U3(i) > Ul(i3)
                U3(i) = Ul(i3);
            end
        end
        n3      = length(U3);
        n123    = n1+n2+n3;
        Ucf     = [U1; U2; U3];
    else
        Ucf     = [U1; U2];
    end
    
    Xcf(1) = -(Tab1.Vehicle - 1)*s; 
    for i = 2:nr
        Xcf(i) = Xcf(i-1) + 0.5*(Ucf(i-1) + Ucf(i))*Ts;
    end
    Xcf    = Xcf';
    size(Ucf);
    size(Xcf);
end