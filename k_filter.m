function [lag] = k_filter(sw_form,p_1,p_2, D_target, omega_0_target,method)
    
    lag.nst_s = -1;

    target.sigma = -omega_0_target * cos(asin(D_target)); %x
    target.omega = omega_0_target * sin(asin(D_target));  %y
    target.s = target.sigma + 1i*target.omega


    
    [offen.nst, offen.pole, offen.k] = zpkdata(sw_form.transferfunction(p_1,p_2), 'v')
    phase_nst = angle(target.s - offen.nst);
    phase_pole = angle(target.s - offen.pole);
    phase_lag_pole = angle(target.s - lag.nst_s);
    syms c;
    phase_should_be_2np1pi = sum(phase_nst) + c - sum(phase_pole) - phase_lag_pole;

    lag.possible_pole_angles = 0;
    for i=-10:10
        lag.possible_pole_angles(length(lag.possible_pole_angles) + 1) = double(solve(phase_should_be_2np1pi==i*pi,c));
    end
    lag.possible_pole_angles(lag.possible_pole_angles==0) = [];
    lag.pole_angle = min(abs(lag.possible_pole_angles));

    if lag.pole_angle<pi*0.5
        lag.pole_s = real(target.s)+imag(target.s)/tan(lag.pole_angle);
    elseif lag.pole_angle>pi*0.5
        lag.pole_s = real(target.s)-imag(target.s)/tan(lag.pole_angle);
    elseif lag.pole_angle == pi
        lag.pole_s = real(target.s);
    end

    geschl.nst = offen.nst;
    geschl.nst(length(geschl.nst) + 1) = lag.nst_s;
    geschl.pole = offen.pole;
    geschl.pole(length(geschl.pole) + 1) = lag.pole_s;


    %calculate absolute value to target point
    d_abs.nst = zeros(length(offen.nst),1);
    for i=1:length(offen.nst)
        d_abs.nst(i) = abs(target.s-offen.nst(i));
    end
    
    d_abs.pole = zeros(length(offen.pole),1);
    for i=1:length(offen.pole)
        d_abs.pole(i) = abs(target.s-offen.pole(i));
    end

    lag.k = prod(d_abs.pole)/prod(d_abs.nst)*1/offen.k

    %[lag.pole_sigma, lag.pole_omega] = pol2cart(D_target + 0.5*pi,omega_0_target);
    %lag.pole_s = lag.pole_sigma + 1i*lag.pole_omega
    
    
end