% this is the main Function calling all subroutines for Fuchs Flight
% Dynamics Simulation

%Setup
clear


%Initial Values
altitude_ft = 30000;
velocity_kn = 275;

enviroment = init_env;
aircraft = init_ac(enviroment);