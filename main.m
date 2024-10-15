% this is the main Function calling all subroutines for Fuchs Flight
% Dynamics Simulation

%Setup
clear
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
sw4x4 = laengsbewegung4x4(eg, enviroment)

val = sw4x4.transferfunction(2,1)
