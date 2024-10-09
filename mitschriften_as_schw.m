function [as_res] = mitschriften_as_schw(eg)
    %händische berechnung
    as_res.sigma = (eg.M_q + eg.Z_alpha);
    as_res.omega_0 = sqrt(eg.M_q * EG.Z_alpha - EG.M_alpha);
    as_res.omega = 
    as_res.D = -as_res.sigma / as_res.omega_0;

    %matlab automatische berechnung
    as_res.A = [eg.M_q eg.M_alpha; 1 eg.Z_alpha];
    as_res.B = 
    as_res.C =
    as_res.D = 

    as_res.eig = eig(as_res.A)
    disp(as_res.eig)
    as_res.statespace = ss(as_res.A, as_res.B, as_res.C, as_res.D, "outputname", ["q_dot", "alpha_dot"], "InputName", ["eta", "delta"]);
    as_res.transferfkt = tf(as_res.statespace);

    pzmap(as_res.statespace); %erzeug poldiagramm
    axis equal;

    rlocus(-as_res.transferfkt(1,1)); %erzeugt wok; 1,1 für erste tf, - weil +steuerausschlag = -reakt

    sgrid(0.707, 3); %whatever?
end