function [p_control] = proportionalrueckfuehrung(schwingung, tf_i1, tf_i2, D_target)
    syms s G k damping

    %zaehler extrahieren
    numerator_cursed = schwingung.transferfunction(tf_i1,tf_i2).Numerator(tf_i1,tf_i2);
    coeff_numerator = numerator_cursed{1};
    l_numerator = length(coeff_numerator);
    p_control.numerator = 0;
    for i=1:l_numerator %numerator zaehler
        p_control.numerator = p_control.numerator + coeff_numerator(i) * power(s,(l_numerator-i));
    end

    %nenner extrahieren
    denominator_cursed = schwingung.transferfunction(tf_i1,tf_i2).Denominator(tf_i1,tf_i2);
    coeff_denominator = denominator_cursed{1};
    l_denominator = length(coeff_denominator);
    p_control.denominator = 0;
    for i=1:l_denominator %numerator zaehler
        p_control.denominator = p_control.denominator + coeff_denominator(i) * power(s,(l_denominator-i));
    end

   
    G = (p_control.numerator) / (p_control.denominator + k * p_control.numerator);
    [z_geschlossen, n_geschlossen] = numden(G);

    %extract coeffs denominator
    all_coeffs = coeffs(collect(n_geschlossen,s),s);

    %calc params
    omega_0 = sqrt(all_coeffs(1)/all_coeffs(3))
    sigma = -(all_coeffs(2)/(2*all_coeffs(3)))
    damping = -sigma/omega_0
    k = solve (damping == D_target, k);
    p_control.k = double(k)
end