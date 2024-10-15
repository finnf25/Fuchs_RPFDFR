function [ersatzgr] = ersatzgroessen(ac,trim)
    ersatzgr.C_Walpha = 2*ac.k*trim.C_A*ac.C_Aalpha;
    ersatzgr.C_Weta = 2*ac.k*trim.C_A*ac.C_Aeta;
    
    ersatzgr.X_V = -((trim.q_dash*ac.S)/(ac.mass*trim.vel_ms)*(2-ac.n_v)*trim.C_W);
    ersatzgr.X_alpha = -((trim.q_dash*ac.S)/ac.mass*ersatzgr.C_Walpha);
    ersatzgr.X_eta = -((trim.q_dash*ac.S)/ac.mass*ersatzgr.C_Weta);
    ersatzgr.X_delta = (trim.q_dash*ac.S)/ac.mass*(trim.C_W/trim.delta);

    ersatzgr.Z_V = -2*((trim.q_dash*ac.S)/(ac.mass*trim.vel_ms)*(trim.C_A/trim.vel_ms));
    ersatzgr.Z_alpha = -((trim.q_dash*ac.S)/(ac.mass*trim.vel_ms)*ac.C_Aalpha);
    ersatzgr.Z_eta = -((trim.q_dash*ac.S)/(ac.mass*trim.vel_ms)*ac.C_Aeta);
    ersatzgr.Z_delta = - ersatzgr.X_delta*((tan(trim.alpha))/trim.vel_ms);

    ersatzgr.M_V = ersatzgr.Z_V * ((trim.q_dash*ac.S*ac.l_mue) / ac.I_y) * (ac.l_mue/trim.vel_ms) * ac.C_madot;
    ersatzgr.M_q = ((trim.q_dash*ac.S*ac.l_mue) / ac.I_y) * (ac.l_mue/trim.vel_ms) * (ac.C_mq + ac.C_madot);
    ersatzgr.M_alpha = ((trim.q_dash*ac.S*ac.l_mue) / ac.I_y) * (ac.C_malpha + ersatzgr.Z_alpha*(ac.l_mue/trim.vel_ms)*ac.C_madot);
    ersatzgr.M_eta = ((trim.q_dash*ac.S*ac.l_mue) / ac.I_y) * (ac.C_meta + ersatzgr.Z_eta*(ac.l_mue/trim.vel_ms)*ac.C_madot);
    ersatzgr.M_delta = ersatzgr.Z_delta * ((trim.q_dash*ac.S*ac.l_mue) / ac.I_y) * (ac.l_mue/trim.vel_ms) * ac.C_madot;
end