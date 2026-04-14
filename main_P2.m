% Kaitlyn Vigil
% ASEN 3802
% Part 3
% 4/14/2026

clc; clear; close all;

%% Part 3
b = 33 + 4/12; % [ft]
c_r = 5 + 4/12; % [ft]
c_t = 3 + 8.5/12; % [ft]
alpha = deg2rad(4); % [rad]

% % Root Airfoil --> NACA 2412
% m_r = 2; p_r = 4; t_r = 12;
% 
% % Tip Airfoil --> NACA 0012
% m_t = 0; p_t = 0; t_t = 12;

% Call PLLT function
[e,c_L,c_Di] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r, N);

% Determine number of of odd terms (N) for each percent error
percent_error = [0.1; 0.01; 0.001];
for i = 1:length(percent_error)
    N_exact = 1000;
    N = 1;

    % CL Exact
    [e,c_L_exact,c_Di] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r, N_exact);
    
    % Create while loop
    c_L_error = 1;
    plot_c_L = [];
    plot_c_Di = [];
    plot_N = [];

    while c_L_error > percent_error(i)
        N = N + 1;
        
        [e,c_L_exact,c_Di] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r, N);
        
        c_L_error = abs((c_L_exact-c_L)/c_L_exact);
        
        plot_c_L(i,N) = c_L;
        plot_c_Di(i,N) = c_Di;
        plot_N(i,N) = N;
    end
end

%% Deliverable 1: (Table 1)
Part3_Table2 = table(percent_error, plot_N, plot_c_L, plot_c_Di); 
Part3_Table2 = renamevars(Part3_Table2, "Var1", "Relative Percent Error");
Part3_Table2 = renamevars(Part3_Table2, "Var2", "N");
Part3_Table2 = renamevars(Part3_Table2, "Var3", "C_L");
Part3_Table2 = renamevars(Part3_Table2, "Var4", "C_Di");

%% Deliverable 2: (Plots --> c_L, c_Di vs N)
figure() % c_L
plot(plot_N(1,:),plot_c_L(1,:))
plot(plot_N(2,:),plot_c_L(2,:))
plot(plot_N(3,:),plot_c_L(3,:))
xlabel("Number of Odd Terms")
ylabel("Coefficent of Lift")
title("Coefficent of Lift Based on Odd Number of Terms for Different Error Values")
legend(percent_error)

figure() % c_Di
plot(plot_N(1,:),plot_c_Di(1,:))
plot(plot_N(2,:),plot_c_Di(2,:))
plot(plot_N(3,:),plot_c_Di(3,:))
xlabel("Number of Odd Terms")
ylabel("Coefficent of Induced Drag")
title("Coefficent of Induced Drag Based on Odd Number of Terms for Different Error Values")
legend(percent_error)

%% Deliverable 3: (Table 2)
V = 100; % [knots]
h = 10000; % [ft]

% Part3_Table2 = table(modes, Lift, D_i, plot_LD); 
% Part3_Table2 = renamevars(Part3_Table2, "Var1", "Relative Percent Error");
% Part3_Table2 = renamevars(Part3_Table2, "Var2", "N");
% Part3_Table2 = renamevars(Part3_Table2, "Var3", "C_L");
% Part3_Table2 = renamevars(Part3_Table2, "Var4", "C_Di");

%% Deliverable 4: (Plots --> C_D vs alpha)

%% Deliverable 5: (Plots --> L/D vs alpha




%% Extra Notes
% This results in a linear spanwise variation of cross-sectional lift
% slope and zero-lift angle of attack

% The wing is also twisted such that the geometric angle of attack varies
% linearly from 1◦ at the root to 0◦ at the tips.