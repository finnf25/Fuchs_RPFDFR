function [rho] = densityofaltitude(env,alt_m)
    rho = env.rho_0 * power((1+ (env.y_H/env.T_0)*alt_m),(-(env.g/(env.R*env.y_H))-1));
end