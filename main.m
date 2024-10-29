% this is the main Function calling all subroutines for Fuchs Flight
% Dynamics Simulation

%Setup
clear
close all
format long

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

val = sw4x4.tf_q_eta

%plots for pole-zero-map and WOK
figure()
pzmap(sw4x4.statespace);
axis equal
figure()
rlocus(-val);
sgrid(1/sqrt(2),3)
axis equal

val2 = proportionalrueckfuehrung(a_sw,1,1,2/sqrt(2));