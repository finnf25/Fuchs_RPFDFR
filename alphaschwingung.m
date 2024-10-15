function [alpha_schw] = alphaschwingung(eg)
    alpha_schw.rho = (eg.M_q + eg.Z_alpha)/2;
    alpha_schw.omega_0 = sqrt(eg.M_q*eg.Z_alpha-eg.M_alpha);
    alpha_schw.omega = sqrt(power(alpha_schw.omega_0, 2) - power(alpha_schw.rho,2));
    alpha_schw.D = - (alpha_schw.rho/alpha_schw.omega_0);
    alpha_schw.T = 2*pi/alpha_schw.omega;

    alpha_schw.A_mat = [eg.M_q eg.M_alpha; 1 eg.Z_alpha];
    alpha_schw.B_mat = [eg.M_eta eg.M_delta; eg.Z_eta eg.Z_delta];
    alpha_schw.C_mat = eye(2);
    alpha_schw.D_mat = [0 0; 0 0];
    
    alpha_schw.eigenwerte = eig(alpha_schw.A_mat);

    alpha_schw.statespace = ss(alpha_schw.A_mat, alpha_schw.B_mat, alpha_schw.C_mat, alpha_schw.D_mat, "outputname", ["q_dot", "alpha_dot"], "InputName", ["eta", "delta"]);
    alpha_schw.transferfunction = tf(alpha_schw.statespace)
end