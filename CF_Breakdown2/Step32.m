function Tabab = Step32
    % Fix U and X where nViol > 0
    global U X Unew Xnew;
    load('cT_Setup.mat')
    Unew  = U;
    Xnew  = X;
    for k = 1:nTrials
        Ul = Unew(:,k);
        Xl = Xnew(:,k);
        if k+1 <= nTrials
            Uf = U(:,k+1);
            Xf = X(:,k+1);
        end
        lead    = k;
        follow  = k+1;
        if follow > nTrials
            break
        end
        % Step 4. Determine Nviol
        [Tab1 Tab2 Tlf] = Step42(Ul,Xl,Uf,Xf,lead,follow);
        if k == 1
            Truns1   = Tab1;
            Truns2   = Tab2;
            Tlfruns  = Tlf;
        else
            Truns1   = [Truns1; Tab1];
            Truns2   = [Truns2; Tab2];
            Tlfruns  = [Tlfruns; Tlf];
        end
        % Step 5. CarFollow
        if Tab1.Nviol > 0
            [Ucf Xcf, Tab3] = Step52(Ul,Xl,Uf,Xf,Tab1,Tab2);
            Vehicle = table(k);
            Tab3    = [Vehicle Tab3];
            Unew(:,k+1) = Ucf;
            Xnew(:,k+1) = Xcf;
            if k == 1
                Tabab = Tab3;
            else
                Tabab = [Tabab; Tab3];
            end
        else
            Tstart   = 0;
            Tend     = 0;
            Ustart   = 0;
            Uend     = 0;
            Xstart   = 0;
            Xend     = 0;
            Tab3     = table(k,Tstart,Tend,Ustart,Uend,Xstart,Xend);
            Unew(:,k+1) = Uf;
            Xnew(:,k+1) = Xf;
            if k == 1
                Tabab = Tab3;
            else
                Tabab = [Tabab; Tab3];
            end
        end      
    end
    Truns1
    Truns2
    Tabab
    Tlfruns
    AverageViolations = mean(Truns1.Nviol)
end