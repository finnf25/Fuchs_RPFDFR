% this is the main Function calling all subroutines for Fuchs Flight
% Dynamics Simulation

%Setup
clear
%close all
format long

plots = false;

%Initial Values
altitude_ft = 30000;
velocity_kn = 275;

enviroment = init_env;
aircraft = init_ac(enviroment);

trim = trimmrechnung(aircraft,enviroment,altitude_ft,velocity_kn,0);
eg = ersatzgroessen(aircraft,trim);

a_sw = alphaschwingung(eg);
b_sw = bahnschwingung(eg,enviroment);
sw4x4 = laengsbewegung4x4(eg, enviroment);


%%plots for pole-zero-map and WOK
if plots==true
    figure()
    pzmap(sw4x4.statespace);
    axis equal
    figure()
    disp(sw4x4.tf_q_eta)
    rlocus(-sw4x4.tf_q_eta);
    sgrid(1/sqrt(2),3)
    axis equal
end

%alpha_sw_p_control = proportionalrueckfuehrung(a_sw,1,1,1/sqrt(2));

k_filter(a_sw,1,1, 1/sqrt(2), 3, 1);
