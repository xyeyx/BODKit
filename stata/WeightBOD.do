/*
    Benefit of the Doubt (BOD) composite indicator 
    Implementation in STATA with illustrative data from Pokemon.
    
    This file concerns the "BOD with Boundary on each Item". 
    
    As an illustration, here the assumption is that each item 
    contributes to no more than 30% in the overall score, and 
    no less than 10%.
    
    
    Author: Xianjia Ye
            Univeristy of Groningen
           
    Date of this version: 2024 JULY 20       
*/

clear all


cd ../data

import delimited pokemon101.csv, case(preserve)

qui mata

DATA = st_data(., ("HP Attack Defense Speed Special")); 

ub = (0.3, 0.3, 0.3, 0.3, 0.3);
lb = (0.1, 0.1, 0.1, 0.1, 0.1);


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

    /* Essential constraints */
    Aineq0 = DATA;
    bineq0 = J(N_Obs, 1, 100);
    
    /* Boundary on the higher side */
    Aineq_high = diag(vi) - diag(ub) * (J(N_Items,1,1) # vi)
    bineq_high = J(N_Items, 1, 0);

    /* Boundary on the lower side */
    Aineq_low =-diag(vi) + diag(lb) * (J(N_Items,1,1) # vi)
    bineq_low = J(N_Items, 1, 0);
    
    Aineq = (Aineq0 \ Aineq_high \ Aineq_low);
    bineq = (bineq0 \ bineq_high \ bineq_low);
    
    q.setInequality(Aineq, bineq);
    q.setCoefficients(vi);
    q.setBounds(lb_w, ub_w);
    q.optimize();
    
    SCORE[i] = q.value();
    WEIGHTS[i,.] = q.parameters();
}


end


getmata (W_HP W_Attack W_Defense W_Speed W_Special)=WEIGHTS
getmata BOD = SCORE


