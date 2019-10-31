function [Tab1 Tab2 Tlf] = Step44(Ul,Xl,Uf,Xf,lead,follow)
    % Estimate Nviol for lead-follow pair
    load('cT_Setup.mat')
    
    % Headway matrix
    H       = zeros(nr,1);  % Headway
    H       = abs(Xl - Xf);
    % Headway violation
    % nviol  = time index where drive discovers that his/her vehicle is too
    % close
    % nstart = time index when driver decelerates vehicle
    % nend   = time index when driver judges that the vehicle is safe distance
    % behind
    nviol   = 0;
    nstart  = 0;
    nend    = 0;
    Tviol   = 0;
    Tstart  = 0;
    Tend    = 0;
    Nviol   = 0;   % number of violations after time t = 10 seconds
    % j = 75:n forces the following driver to respond at t=10 seconds for a
    % headway violation
    for j = 75:nr
        if H(j) < round(s)
            Nviol = Nviol + 1;
        end
    end
    for k = 75:nr
        if(H(k) <= round(s) & nviol == 0 & Tr(k) >= 0 & Nviol > 0) 
            nviol   = k;
            nstart  = k + 2.5/Ts; 
            % Driver response time is assumed to be 2.5 seconds
            Tviol   = Tr(k);
            Tstart  = Tr(k) + 2.5;
        end
    end
    vehicle = [lead follow]';
    if nstart == 0
        message = {'No breakdown triggering'};
        Vehicle = vehicle(2);
        table(message, Vehicle, Nviol);
        Tviol  = 0;
        Tstart = 0;
        Tend   = 0;
        nviol  = 0;
        nstart = 0;
        nend   = 0;
        dT     = 0;
        Nviol  = 0;
    end
    if nstart == 0
        nstart = 10;
    end
    Ulm     = 0.3048*Ul(nstart); 
    Ufm     = 0.3048*Uf(nstart);
    Xlm     = 0.3048*Xl(nstart); 
    Xfm     = 0.3048*Xf(nstart);
    Times   = [Tstart Tend]';
    U_start = Ufm;
    X_start = Xfm;
    accl    = Ul(100)/10;
    accf    = Uf(100)/10;
    Accel_10m = 0.3048*accf;
    Vehicle = vehicle(2);
    Tlf     = table(Vehicle, Accel_10m, U_start, X_start);  
    % Find Tend 
    if nstart > 0
        dT      = -1*(Xl(nstart) - Xf(nstart))/(Ul(nstart) - Uf(nstart));
        Tend    = Tstart + dT;
        nend    = round(nstart + dT/Ts);
             
        if (dT <= 0)
            for k = nstart:nr-1
                if(H(k) <= round(s) & H(k+1) >= round(s)) 
                    Tend  = Tr(k+1);
                    nend  = k+1;    
                end
            end
        end
        if (nend <= 0 | nend <= nr | Tend > 60)
            nend = nr-1;
            Tend = Tf;    
        end
            
        % Messages
        if (Tend > 60 & Nviol > 0)
            Vehicle = vehicle(2);
            message = {'Two-Phase'};
            table(message,  Vehicle, Nviol);
        elseif (Tend < 60 & Nviol > 0)
            Vehicle = vehicle(2);
            message = {'Three-Phase'};
            table(message, Vehicle, Nviol);
        end
    end
    Vehicle = vehicle(2);
    Tab1    = table(Vehicle,Tviol,Tstart,Tend,dT,Nviol);
    Tab2    = table(Vehicle,nviol,nstart,nend,dT,Nviol);
end