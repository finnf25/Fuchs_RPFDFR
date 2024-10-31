function [lag] = k_filter(sw_form,p_1,p_2, D_target, omega_0_target,method)
    
    %lag nst legen (gegeben)
    lag.pole_s = -1;

    %ziel-punkt in komplexe zahl
    target.sigma = -omega_0_target * cos(asin(D_target)); %x
    target.omega = omega_0_target * sin(asin(D_target));  %y
    target.s = target.sigma + 1i*target.omega

    %pole, nst und k bestimmen
    [offen.nst, offen.pole, offen.k] = zpkdata(sw_form.transferfunction(p_1,p_2), 'v')

    %winkel aller bekannten Punkte zu ziel-punkt
    phase_nst = angle(target.s - offen.nst);
    phase_pole = angle(target.s - offen.pole);
    phase_lag_pole = angle(target.s - lag.pole_s);

    %gleichung zur bestimmung des fehlenden winkels
    syms c;
    phase_should_be_2np1pi = sum(phase_nst) + c - sum(phase_pole) - phase_lag_pole;

    %iteration um phase = (2n + 1)*pi
    lag.possible_nst_angles = 0;
    for i=-10:10
        lag.possible_nst_angles(length(lag.possible_nst_angles) + 1) = double(solve(phase_should_be_2np1pi==i*pi,c));
    end

    %suche kleinsten winkel des pols
    lag.possible_nst_angles(lag.possible_nst_angles==0) = [];
    lag.nst_angle = min(abs(lag.possible_nst_angles));

    %rekonstruieren des gesamten pols
    if lag.nst_angle<pi*0.5
        lag.nst_s = real(target.s)-imag(target.s)/tan(lag.nst_angle);
    elseif lag.nst_angle>pi*0.5
        lag.nst_s = real(target.s)+imag(target.s)/tan(lag.nst_angle);
    elseif lag.nst_angle == pi
        lag.nst_s = real(target.s);
    end

    %erstellen der TF für geschlossenen Kreis
    geschl.nst = offen.nst;
    geschl.nst(length(geschl.nst) + 1) = lag.nst_s;
    geschl.pole = offen.pole;
    geschl.pole(length(geschl.pole) + 1) = lag.pole_s

    %absolute distanzen zw allen Punkten und Ziel-Punkt berechnen (um k zu
    %finden)
    d_abs.nst = zeros(length(offen.nst),1);
    for i=1:length(offen.nst)
        d_abs.nst(i) = abs(target.s-geschl.nst(i));
    end
    
    d_abs.pole = zeros(length(offen.pole),1);
    for i=1:length(offen.pole)
        d_abs.pole(i) = abs(target.s-geschl.pole(i));
    end

    %k berechnen
    lag.k = prod(d_abs.pole)/prod(d_abs.nst)*1/offen.k

    %tf extrahieren und plotten
    lag.transferfunction = zpk(geschl.nst,geschl.pole,lag.k);

    tf = lag.transferfunction

    rlocus(-lag.transferfunction)
    sgrid(D_target,omega_0_target)
    
    
end