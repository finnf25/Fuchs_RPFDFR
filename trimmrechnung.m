function [trim_results] = trimmrechnung(ac,env,altitude_ft,V_IASref,alpha_refINIT)
    %alt from ft to m
    altitude_m = 0.30479 * altitude_ft;

    %get rho of alt
    rho = densityofaltitude(env,altitude_m);

    %calc TAS
    velocity_ms = sqrt(env.rho_0/rho)*(1852/3600) * V_IASref;

    %qdash
    q_dash = (rho/2)*power(velocity_ms,2);

    %trim init
    alpha_ref = alpha_refINIT;
    rho_ref = rho;
    %does not change, so use as initial value
    C_Aref = (2*ac.mass*env.g)/(rho_ref*power(velocity_ms,2)*ac.S); % const

    %iteration
    for i=1:10
        eta_ref = -(ac.C_m_alpha0eta0 + (C_Aref- ac.C_A_alpha0eta0)*(ac.C_malpha/ac.C_Aalpha))/(ac.C_meta - ac.C_Aeta*(ac.C_malpha/ac.C_Aalpha));
        alpha_ref = (C_Aref - ac.C_A_alpha0eta0 - ac.C_Aeta*eta_ref)/ac.C_Aalpha;
        
        C_Wref = ac.C_W0 + ac.k*power(C_Aref,2);
        W_ref = C_Wref*(rho_ref/2)*power(velocity_ms,2)*ac.S;
        F_ref = W_ref / cos(alpha_ref);
        delta_ref = F_ref/(ac.F_TBPmax*power(rho_ref/ac.rho_TBP,ac.n_p));

        A_ref = ac.mass*env.g - F_ref*sin(alpha_ref);
        C_Aref = A_ref/((rho_ref/2)*power(velocity_ms,2)*ac.S);
    end

    %reformat
    trim_results.alt_m = altitude_m;
    trim_results.rho_H = rho;
    trim_results.vel_ms = velocity_ms;
    trim_results.q_dash = q_dash;
    trim_results.alpha = alpha_ref;
    trim_results.C_A = C_Aref;
    trim_results.eta = eta_ref;
    trim_results.C_W = C_Wref;
    trim_results.W = W_ref;
    trim_results.A = A_ref;
    trim_results.F = F_ref;
    trim_results.delta = delta_ref

end