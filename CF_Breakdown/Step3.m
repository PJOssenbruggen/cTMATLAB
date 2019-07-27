function Step3
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
        [Tab Tlf] = Step4(Ul,Xl,Uf,Xf,lead,follow);
        if k == 1
            Truns   = Tab;
            Tlfruns = Tlf;
        else
            Truns   = [Truns; Tab];
            Tlfruns = [Tlfruns; Tlf];
        end
        % Step 5. CarFollow
        if Tab.Nviol > 0
            [Ucf Xcf] = Step5(Ul,Xl,Uf,Xf,Tab);
            Unew(:,k+1) = Ucf;
            Xnew(:,k+1) = Xcf;
        else
            Unew(:,k+1) = Uf;
            Xnew(:,k+1) = Xf;
        end   
    end
    Truns
    Tlfruns
end