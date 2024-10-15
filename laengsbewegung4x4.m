function [res] = laengsbewegung4x4(eg, env)
    res.A_mat = [eg.X_V -env.g 0 eg.X_alpha; -eg.Z_V 0 0 -eg.Z_alpha; eg.M_V 0 eg.M_q eg.M_alpha; eg.Z_V 0 1 eg.Z_alpha];
    res.B_mat = [eg.X_eta eg.X_delta; -eg.Z_eta -eg.Z_delta; eg.M_eta eg.M_delta; eg.Z_eta eg.Z_delta];
    res.C_mat = diag([1 1 1 1]);
    res.D_mat = [0 0; 0 0; 0 0; 0 0];
    res.eigenwerte = eig(res.A_mat);
    res.statespace = ss(res.A_mat, res.B_mat, res.C_mat, res.D_mat, "outputname", ["V_dot", "gamma_dot", "q_dot", "alpha_dot"], "InputName", ["eta", "delta"]);
    res.transferfunction = tf(res.statespace);

    pzmap(res.statespace);
    rlocus(res.transferfunction(1,1));

end