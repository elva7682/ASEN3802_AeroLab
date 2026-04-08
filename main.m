
clc
clear
close all



%% Task 1

[x_0021, y_0021, yc_0021] = NACA_Airfoils(0,0,21,1,50);


figure
hold on
scatter(x_0021,y_0021)
xlim([0,1])
ylim([-0.5,0.5])
title("NACA0021 Airfoil")
hold off

[x_2421, y_2421, yc_2421] = NACA_Airfoils(2,4,21,1,50);


figure
hold on
scatter(x_2421,y_2421)
plot(x_2421,yc_2421)
xlim([0,1])
ylim([-0.5,0.5])
title("NACA2421 Airfoil")
hold off



%% Task 2
% Call NACA_Airfoil with NACA 0012
m = 0; p = 0; t = 12; c = 1;
alpha = 12; % [deg]
N_exact = 1000;
N = 1;

[x_be, y_be] = NACA_Airfoils(m,p,t,c,N_exact);
cl_exact = Vortex_Panel(x_be, y_be, alpha);

% Create while loop
cl_error = 1;

while cl_error >= 0.01
    N = N + 1;
    [x_b, y_b] = NACA_Airfoils(m,p,t,c,N);
    
    cl = Vortex_Panel(x_b, y_b,alpha);
    cl_error = abs((cl_exact-cl)/cl_exact);
    
end

fprintf('Final cl: %.4f\n', cl);
fprintf('Number of panels N: %d\n', N);


%% Task 3

% Plot predicted cl over a range of alpha for each 
naca_0006 = load("0006.mat");
naca_0012 = load("0012.mat");
