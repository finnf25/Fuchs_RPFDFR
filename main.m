% this is the main Function calling all subroutines for Fuchs Flight
% Dynamics Simulation

%Setup
clear
close all
format long

plots = false;

%Initial Values
altitude_array = 25000:1000:35000;
velocity_tas_array = 400:10:500;

lag_k_out_mat = zeros(length(velocity_tas_array),length(altitude_array));

for vel_id=1:length(velocity_tas_array)
    velocity_kn = velocity_tas_array(vel_id);
    
    for alt_id=1:length(altitude_array)
        altitude_ft = altitude_array(alt_id);
        
        enviroment = init_env;
        aircraft = init_ac(enviroment);
        
        trim = trimmrechnung(aircraft,enviroment,altitude_ft,velocity_kn,0,false);
        eg = ersatzgroessen(aircraft,trim);
        
        a_sw = alphaschwingung(eg);
        b_sw = bahnschwingung(eg,enviroment);
        sw4x4 = laengsbewegung4x4(eg, enviroment);
        
        %alpha_sw_p_control = proportionalrueckfuehrung(a_sw,1,1,1/sqrt(2));
        
        lag_k_out_mat(vel_id,alt_id) = k_filter(a_sw,1,1, 1/sqrt(2), 3).k;
    end
end

% Erstelle ein Gitter für Höhen und Geschwindigkeiten
[alt_mesh, vel_mesh] = meshgrid(altitude_array, velocity_tas_array);

% Oberflächenplot erstellen
figure;
surf(alt_mesh, vel_mesh, lag_k_out_mat);

% Achsenbeschriftungen und Titel
xlabel('Höhe');
ylabel('Geschwindigkeit');
zlabel('Parameter k');
title('Plot des Parameters k über Höhe und Geschwindigkeit');


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