function [Scores, Weights] = UnrestrictedBOD(dt)

    % c: counts of entries, 
    % n: number of items.
    [c, n] = size(dt);

    
    if n==1
       x = max(dt);
       Scores = dt*100/x;
       Weights = ones(1/x);
       return
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

        C=[C1; C2];
        C(isnan(C))=0;
        R=[R1, R2];
        x = linprog(f, C, R,[],[],[],[],  linprog_options);
        Wgt = [Wgt; x'];
        Sc = [Sc; vi*x];

    end


    Weights = Wgt;
    Scores = Sc;
end

