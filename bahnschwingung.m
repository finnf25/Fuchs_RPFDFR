function [bahn_schw] = bahnschwingung(eg, env)
    bahn_schw.sigma = (eg.X_V)/2;
    bahn_schw.omega_0 = sqrt(-env.g*eg.Z_V);
    bahn_schw.omega = sqrt(power(bahn_schw.omega_0,2) - power(bahn_schw.sigma,2));
    bahn_schw.D = - bahn_schw.sigma /bahn_schw.omega_0;
    bahn_schw.T = 2*pi / bahn_schw.omega;

    bahn_schw.A_mat = [eg.X_V -env.g; -eg.Z_V 0];
    bahn_schw.B_mat = [eg.X_eta eg.X_delta; -eg.Z_eta -eg.Z_delta];
    bahn_schw.C_mat = eye(2);
    bahn_schw.D_mat = [0 0; 0 0];

    bahn_schw.eigenwerte = eig(bahn_schw.A_mat);

    bahn_schw.statespace = ss(bahn_schw.A_mat, bahn_schw.B_mat, bahn_schw.C_mat, bahn_schw.D_mat, "outputname", ["V_dot", "gamma_dot"], "InputName", ["eta", "delta"]);
    bahn_schw.transferfunction = tf(bahn_schw.statespace);

    bahn_schw.tf_V_eta = bahn_schw.transferfunction(1,1);
    bahn_schw.tf_gamma_eta = bahn_schw.transferfunction(2,1);
    bahn_schw.tf_V_delta = bahn_schw.transferfunction(1,2);
    bahn_schw.tf_gamma_delta = bahn_schw.transferfunction(2,2);
end