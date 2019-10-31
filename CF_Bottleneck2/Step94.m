function [Unew, Xnew] = Step94(U, X, newTrials, Vehicle)
    % " Step 8: Merge Zone"
    % Fix U and X where nViol > 0
    load('cT_Setup.mat')
    Unew   = U;
    Xnew   = X;
    t1     = 0:Ts:Tr(301);
    t2     = Tr(302):Ts:Tr(421);
    t3     = Tr(422):Ts:Tr(601);
    index1 = 1:301;
    index2 = 302:421;
    index3 = 422:601;
    Tstart = Tr(302);
    Tend   = Tr(421);
    Vcount = 0;
    lead   = 1;
    follow = 1;
    H      = 0;
    Hnew   = 0;
    unew   = U(421,1);
    u0     = U(421,1); 
    Vehicle;
    
    % Brownian Motion of Speed from t = 42 to 60 seconds
    U3      = U(422:601,:);
    Unew(422:601,1) = U3(:,1);
    % Vehicle k = 1
    k         = 1;
    for i = 422:601
        Xnew(i,k) = Xnew(i-1,k) + 0.5*(Unew(i-1,k) + Unew(i,k))*Ts;
    end
    for k  = 2:newTrials    % k = following vehicle
       for i = 422:601
            if Unew(i,k) < 0
                    Unew(i,k) = 0;
            end
            Xnew(i,k) = Xnew(i-1,k) + 0.5*(Unew(i-1,k) + Unew(i,k))*Ts;
            % Remove headway violations
            if Xnew(i,k-1) - Xnew(i,k) < s
                H           = Xnew(i,k-1) - Xnew(i,k);
                Xnew(i,k)   = Xnew(i,k-1) - s;
                Unew(i,k)   = Unew(i,k-1); % Follow u = lead u   
            end
       end 
    end
end 

