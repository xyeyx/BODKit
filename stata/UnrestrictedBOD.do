/*
    Benefit of the Doubt (BOD) composite indicator 
    Implementation in STATA with illustrative data from Pokemon.
    
    This file concerns the "Unrestricted BOD". 
    
    
    Author: Xianjia Ye
            Univeristy of Groningen
           
    Date of this version: 2024 JULY 20       
*/

clear all


cd ../data

import delimited pokemon101.csv, case(preserve)

qui mata

DATA = st_data(., ("HP Attack Defense Speed Special")); 

/* CORE PART BELOW TO BE CREATED AS MODULE */
N_Obs = rows(DATA);
N_Items = cols(DATA);
SCORE = J(N_Obs, 1, .);
WEIGHTS = J(N_Obs, N_Items, .); 

q=LinearProgram();
ub_w = (., ., ., ., .);
lb_w = (0,0,0,0,0);


for (i = 1; i<= N_Obs; i++) {
    vi = DATA[i, ];
    Aineq = DATA;
    bineq = J(rows(DATA), 1, 100);

    q.setInequality(Aineq, bineq);
    q.setCoefficients(vi);
    q.setBounds(lb_w, ub_w);
    q.optimize();
    
    SCORE[i] = q.value();
    WEIGHTS[i,.] = q.parameters();
}


end


getmata (W_HP W_Attack W_Defense W_Speed W_Special)=WEIGHTS
getmata BOD_Unrestricted = SCORE


