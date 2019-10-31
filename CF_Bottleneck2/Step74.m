function [U,X,nTrials] = Step74(Uleft, Xleft, Uright, Xright, nTrials)
    % "Step 7: Arrange vehicles by their arrival time 30 seconds"
    Xorder = [Xleft(301,:)'; Xright(301,:)'];
    sz     = size(Xorder);
    Xorder = reshape(Xorder,[sz(1)*sz(2),1]);
    [B,I]  = sort(Xorder, 'descend');
    for j = 1:2*nTrials
        if j == 1
            if I(j) <= nTrials 
                ind = I(j);
                U   = Uleft(:,ind);
                X   = Xleft(:,ind);
            else
                ind = I(j) - nTrials;
                U   = Uright(:,ind);
                X   = Xright(:,ind);
            end
        else
            if I(j) <= nTrials
                ind = I(j);
                U   = [U Uleft(:,ind)];
                X   = [X Xleft(:,ind)];
            else
                ind = I(j) - nTrials;
                U   = [U Uright(:,ind)];
                X   = [X Xright(:,ind)];
            end
        end
    end
    nTrials = 2*nTrials;