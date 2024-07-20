/*
    Benefit of the Doubt (BOD) composite indicator 
    Implementation in STATA with illustrative data from Pokemon.
    
    This file concerns the "BOD with Boundary on groups of Item". 
    
    As an illustration, here it considers that the three pillars 
    of HP, Attack and Defense forms a category of Physics, and 
    Speed and Special as Magic. With real world data the categories
    can be decided with the help of e.g. principle factor analysis,
    which is also the case here that the first three and later two
    are forming two clusters from PCA factor loadin outcomes. 
    
    Then, each of the pillar can take up to 70% of contribution,
    and no less than 30% of the contribution.
    
    
    Author: Xianjia Ye
            Univeristy of Groningen
           
    Date of this version: 2024 JULY 20       
*/

clear all


cd ../data

import delimited pokemon101.csv, case(preserve)

qui mata

DATA = st_data(., ("HP Attack Defense Speed Special")); 

/* HP, Attach and Defense as the cluster as Physics,
   Speed and Special as Magic */
catMat = (1,0 \ 1,0 \ 1,0 \ 0,1 \ 0,1);

/* Boundary for items fall in the two categories */
ub = (0.7, 0.7);
lb = (0.3, 0.3);


/* CORE PART BELOW TO BE CREATED AS MODULE */
N_Obs = rows(DATA);
N_Items = cols(DATA);
N_Cats = cols(catMat);
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
    Aineq_high = catMat'*diag(vi) - diag(ub) * (J(N_Cats,1,1) # vi)
    bineq_high = J(N_Cats, 1, 0);

    /* Boundary on the lower side */
    Aineq_low =-catMat'*diag(vi) + diag(lb) * (J(N_Cats,1,1) # vi)
    bineq_low = J(N_Cats, 1, 0);
    
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


