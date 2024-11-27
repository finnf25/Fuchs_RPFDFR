% this is the main Function calling all subroutines for Fuchs Flight
% Dynamics Simulation

%% Setup
clear
close all
format long

plots = false;

%% Initial Values
altitude_array = 15000:1000:45000;
velocity_tas_array = 300:10:600;

%output matrix for output parameter to be plotted over whole range of
%vel/alt
lag_k_out_mat = zeros(length(velocity_tas_array),length(altitude_array));
lag_mat_nst = zeros(length(velocity_tas_array),length(altitude_array));

%iteration over all velocities
for vel_id=1:length(velocity_tas_array)
    velocity_kn = velocity_tas_array(vel_id);
    
    %iteration over all speeds
    for alt_id=1:length(altitude_array)
        altitude_ft = altitude_array(alt_id);
        
        %init enviroment and aircraft
        enviroment = init_env;
        aircraft = init_ac(enviroment);
        
        %do trim and ersatzgroessen calc
        trim = trimmrechnung(aircraft,enviroment,altitude_ft,velocity_kn,0,false);
        eg = ersatzgroessen(aircraft,trim);
        
        %calculate movements in different ways
        a_sw = alphaschwingung(eg);
            %b_sw = bahnschwingung(eg,enviroment);
            %sw4x4 = laengsbewegung4x4(eg, enviroment);
        
            %alpha_sw_p_control = proportionalrueckfuehrung(a_sw,1,1,1/sqrt(2));
        
        %calculate lag proportional gain for all possible alt/vel
        %combinations
        lag_k_out_mat(vel_id,alt_id) = k_filter(a_sw,1,1, 1/sqrt(2), 3).k;
        lag_mat_nst(vel_id,alt_id) = k_filter(a_sw,1,1, 1/sqrt(2), 3).nst_s;
    end
end

%% Show parameter k as mesh-plot
[alt_mesh, vel_mesh] = meshgrid(altitude_array, velocity_tas_array);

figure;
surf(alt_mesh, vel_mesh, lag_k_out_mat);
xlabel('Höhe');
ylabel('Geschwindigkeit');
zlabel('Parameter k');
title('Plot des Parameters k über Höhe und Geschwindigkeit');

%% Show nst as mesh-plot
figure;
surf(alt_mesh, vel_mesh, lag_mat_nst);
xlabel('Höhe');
ylabel('Geschwindigkeit');
zlabel('nst');
title('Plot der NST über Höhe und Geschwindigkeit');

%% plots for pole-zero-map and WOK
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