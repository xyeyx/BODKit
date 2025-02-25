function [Scores, Weights] = WgtCatBOD(dt, catMat, UpperB,LowerB)
    % Author: Xianjia Ye
    %         University of Groningen
    % This version: 2024 JULY 20

    % Verification of data
    % c: counts of entries, 
    % cats: number of categories,
    % n: number of pillars
    [c, n] = size(dt);

    [n1, cats] = size(catMat);
    
    sizewgt1 = size(UpperB(:));
    sizewgt2 = size(LowerB(:));

    if n1~=n
        error(['Number of factors in the data and in the ', ...
               'category matrix does not match.'])
    end
    
    if cats>=n
        error(['Number of factors in the data must be larger', ...
               'than the number of summary categories.'])
    end

    if n==1
       Scores = dt;
       Weights = ones(size(dt));
    end

    if or((sizewgt1 ~= sizewgt2) , (cats*2~=sizewgt1+sizewgt2))
        error(['Wrong size of the bound matrix. ', ...
            'They must equal the number of categories.']);
    end
    
    if min(UpperB(:)-LowerB(:))< 0
         error('Upper bound should be no smaller than lower bound.');
    end
    
    if sum(UpperB(:))<1
        error('Sum of upper bound weights should be no smaller than 1.');
    end

    if sum(LowerB(:))>1
        error('Sum of lower bound weights should be no larger than 1.');
    end

    Wgt=[];
    Sc =[];
    linprog_options = optimoptions('linprog','Display','none');
    
    for i = (1:c)
        % Fetch the values of the individual i
        vi = dt(i, :);

        % Building up the LP problem for solving B.O.D:
    
        % Target function to be maximized (i.e. inverse of minimize)
        f = -vi;

        % Condition 1: If the weight is applied to any of individual, it 
        %              should not yield a performance beyound 100%.
        C1 = dt;
        R1 = ones(1, c).*100;

        % Condition 2: The weights are all non-negative.
        C2 = -eye(n);
        R2 = zeros(1, n);

        % Condition 3: The contribution of each category is smaller than
        %              maximum allowed boundary.
        C3 = catMat'*diag(vi) - diag(UpperB)*kron(ones(cats, 1), vi);
        R3 = zeros(1, cats);


        % Condition 4: The contribution of each category is larger than
        %              minimum allowed boundary.
        C4 = -catMat'*diag(vi) + diag(LowerB)*kron(ones(cats, 1), vi);
        R4 = zeros(1,cats);

        C=[C1; C2; C3; C4];
        C(isnan(C))=0;
        R=[R1, R2, R3, R4];
        x = linprog(f, C, R,[],[],[],[],  linprog_options);
        Wgt = [Wgt; x'];
        Sc = [Sc; vi*x];

    end

    Weights = Wgt;
    Scores = Sc;
end

