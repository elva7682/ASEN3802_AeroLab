%% ASEN 3802 - Aerodynamics Lab - Main
%  Task 1: Generates coordinates describing the surface of a 4-digit NACA
%  airfoil
%  Task 2: Determines minimum number of panels needed to calculate lift
%  coefficient within 1% error using Vortex Panel Method
%  Task 3: Analyzes symmetric NACA airfoils using Thin Airfoil Theory and
%  Vortex Panel Method
%  Task 4: Analyzes cambered NACA airfoils using Thin Airfoil Theory and
%  Vortex Panel Method
%
% Authors: Elisabeth van Reijendam, Kaitlyn Vigil
% Collaborators: Brady Hormuth, Samuel Meyn
% Date: 4/8/2026

clc
clear
close all



%% Task 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NACA0021 Airfoil
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x_0021, y_0021, yc_0021] = NACA_Airfoils(0,0,21,1,50); % calculate airfoil shape

% Plot airfoil shape
figure(Theme="Light")
hold on
plot(x_0021,y_0021, "-o")
xlim([0,1])
ylim([-0.5,0.5])
title("NACA0021 Airfoil")
xlabel("x position (% chord)")
ylabel("y position (% chord)")
grid on
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NACA2421 Airfoil
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x_2421, y_2421, yc_2421] = NACA_Airfoils(2,4,21,1,50); % calculate airfoil shape

% Plot airfoil shape
figure(Theme="Light")
hold on
plot(x_2421,y_2421, "-o")
plot(x_2421,yc_2421)
xlim([0,1])
ylim([-0.5,0.5])
title("NACA2421 Airfoil")
xlabel("x position (% chord)")
ylabel("y position (% chord)")
grid on
hold off



%% Task 2

%%%%%%%%%%%%%%%%%%%%%%%
% NACA 0012 Properties 
%%%%%%%%%%%%%%%%%%%%%%%
m = 0; p = 0; t = 12; c = 1;
alpha = 12; % [deg]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine exact lift coefficient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_exact = 1000;
[x_be, y_be] = NACA_Airfoils(m,p,t,c,N_exact);
cl_exact = Vortex_Panel(x_be, y_be,0, alpha);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the minimum N panels needed to get within 1% of exact lift coeff.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cl_error = 1;
plot_cl = [];
plot_N = [];
N = 1;

while cl_error > 0.01
    N = N + 1;
    [x_b, y_b] = NACA_Airfoils(m,p,t,c,N);
    
    cl = Vortex_Panel(x_b, y_b, 0,alpha);
    cl_error = abs((cl_exact-cl)/cl_exact);
    
    plot_cl(N) = cl;
    plot_N(N) = N;
end


%%%%%%%%%%%%%%%%%%
% Display Results
%%%%%%%%%%%%%%%%%%
disp("Task 2 Results: ")
disp("Exact lift coefficient, Final lift coefficient (calculated with minimum N panels to be within 1% of exact lift coefficient), and minimum N panels to be within 1% of exact lift coefficient")
fprintf('Exact cl: %.6f\n', cl_exact);
fprintf('Final cl: %.6f\n', cl);
fprintf('Number of panels N: %d\n', N);

%%%%%%%%%%%%%%%%%%%
% Convergence Plot
%%%%%%%%%%%%%%%%%%%
figure()
plot(plot_N,plot_cl, "b")
yline(cl_exact, "r")
xline(N, "--")
xlabel("Number of Panels")
ylabel("Predicted Sectional Coefficient of Lift")
title("Convergence Plot of the Predicted Sectional Lift Coefficient")
legend("Convergence Line", "Exact Solution", "Minimum Number of Panels")

%%%%%%%%%%%%%%%%%%%
% Table Comparison
%%%%%%%%%%%%%%%%%%%
Comp_Table = table([cl;cl_exact], [N;N_exact], [cl_error;0],  'VariableNames',["Lift Coefficient", "Number of Panels (N)","% Lift Coefficient Error"]);
disp(Comp_Table)



%% Task 3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a vector of angle of attack values (degrees)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpha = -16:1:20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate 0 Lift angle of attack using Thin Airfoil Theory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[taf_cl_0006, naca_0006_alpha0] = ThinAirfoil(1,0,0,N, alpha); % NACA0006
[taf_cl_0012, naca_0012_alpha0] = ThinAirfoil(1,0,0,N, alpha); % NACA0012
[taf_cl_0018,naca_0018_alpha0] = ThinAirfoil(1,0,0,N, alpha); % NACA0018


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate Airfoil Shape
%%%%%%%%%%%%%%%%%%%%%%%%%%
[x_0006, y_0006, yc_0006] = NACA_Airfoils(0,0,6,1,N); % NACA0006
[x_0012, y_0012, yc_0012] = NACA_Airfoils(0,0,12,1,N); % NACA0012
[x_0018, y_0018, yc_0018] = NACA_Airfoils(0,0,18,1,N);  % NACA0018


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preallocate vectors for Vortex Panel Method Lift Coefficient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vpm_cl_0006 = zeros(size(alpha)); % NACA0006
vpm_cl_00012 = zeros(size(alpha)); % NACA0012
vpm_cl_0018 = zeros(size(alpha)); % NACA0018


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use Vortex Panel Method to calculate lift coefficient across all alpha
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(alpha)
    vpm_cl_0006(i) = Vortex_Panel(x_0006,y_0006,0,alpha(i)); % NACA0006
    vpm_cl_00012(i) = Vortex_Panel(x_0012,y_0012,0,alpha(i)); % NACA0012
    vpm_cl_0018(i) = Vortex_Panel(x_0018,y_0018,0,alpha(i)); % NACA0018
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load in experimental data (from digitized NACA charts)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
naca_0006 = load("0006.mat"); % NACA0006
naca_0012 = load("0012.mat"); % NACA0012


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Lift Coefficient for each airfoil and method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(Theme="Light")
hold on
plot(naca_0006.data(:,1),naca_0006.data(:,2), "DisplayName","NACA0006 Experimental", 'Color','r') % NACA0006 Experimental
plot(naca_0012.data(:,1),naca_0012.data(:,2), "DisplayName","NACA0012 Experimental", 'Color','g') % NACA0012 Experimental
plot(alpha, vpm_cl_0006, "DisplayName","NACA0006 Vortex Panel Method", 'Color','r', 'LineStyle', '--') % NACA0006 Vortex Panel Method
plot(alpha, vpm_cl_00012, "DisplayName","NACA0012 Vortex Panel Method", 'Color','g', 'LineStyle', '--') % NACA0012 Vortex Panel Method
plot(alpha, vpm_cl_0018, "DisplayName","NACA0018 Vortex Panel Method", 'Color','c', 'LineStyle', '--') % NACA0018 Vortex Panel Method
plot(alpha, taf_cl_0006, "DisplayName","NACA0006 Thin Airfoil Theory", 'Color','r', 'Marker', 'o') % NACA0006 Thin Airfoil Theory
plot(alpha, taf_cl_0012, "DisplayName","NACA0012 Thin Airfoil Theory", 'Color','g', 'Marker', '^') % NACA0012 Thin Airfoil Theory
plot(alpha,taf_cl_0018, "DisplayName","NACA0018 Thin Airfoil Theory", 'Color','c', 'Marker', '*') % NACA0018 Thin Airfoil Theory
legend('Location', 'northwest')
title("Lift Distribution Comparison")
xlabel("Angle of Attack (Degrees)")
ylabel("Lift Coefficient (cl)")
grid on
hold off



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create and display a table comparing zero lift AoA and lift slope
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpha0_taf = [naca_0006_alpha0,naca_0012_alpha0,naca_0018_alpha0]'; % Thin Airfoil Theory Zero Lift AoA
alpha0_vpm = [ min(alpha(vpm_cl_0006 > -0.05)),min(alpha(vpm_cl_00012 > -0.05)),min(alpha(vpm_cl_0018 > -0.05))]'; % Vortex Panel Method Zero Lift AoA
a_vpm = [mean(diff(vpm_cl_0006)),mean(diff(vpm_cl_00012)),mean(diff(vpm_cl_0018))]'; % Vortex Panel Method Zero Lift Slope
a_taf = [mean(diff(taf_cl_0006)),mean(diff(taf_cl_0012)),mean(diff(taf_cl_0018))]'; % Thin Airfoil Theory Zero Lift Slope
disp("Task 3 Results: Comparison of Zero Lift AoA and Lift Slope for Thin Airfoil Theory and Vortex Panel Method")
T = table(alpha0_taf,alpha0_vpm,a_taf,a_vpm,'VariableNames',["Zero Lift AoA (Thin Airfoil Theory)","Zero Lift AoA (Vortex Panel Method)", "Lift Slope (Thin Airfoil Theory)", "Lift Slope (Vortex Panel Method)"],'RowNames',["NACA0006","NACA0012","NACA0018"]);
disp(T)



%% Task 4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load in experimental data (from digitized NACA charts)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
naca_2412 = load("2412.mat"); % NACA2412
naca_4412 = load("4412.mat"); % NACA4412

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate 0 Lift angle of attack using Thin Airfoil Theory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[taf_cl_2412, naca_2412_alpha0] = ThinAirfoil(1,2,4,N, alpha); % NACA2412
[taf_cl_4412,naca_4412_alpha0] = ThinAirfoil(1,4,4,N, alpha); % NACA4412



%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate Airfoil Shape
%%%%%%%%%%%%%%%%%%%%%%%%%%
[x_2412, y_2412, yc_2412] = NACA_Airfoils(2,4,12,1,N); % NACA2412
[x_4412, y_4412, yc_4412] = NACA_Airfoils(4,4,12,1,N); % NACA4412


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preallocate vectors for Vortex Panel Method Lift Coefficient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vpm_cl_2412 = zeros(size(alpha)); % NACA2412
vpm_cl_4412 = zeros(size(alpha)); % NACA4412



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use Vortex Panel Method to calculate lift coefficient across all alpha
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(alpha)
    vpm_cl_2412(i) = Vortex_Panel(x_2412,y_2412,0,alpha(i)); % NACA2412
    vpm_cl_4412(i) = Vortex_Panel(x_4412,y_4412,0,alpha(i)); % NACA4412
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Lift Coefficient for each airfoil and method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(Theme="Light")
hold on
plot(naca_2412.data(:,1),naca_2412.data(:,2), "DisplayName","NACA2412 Experimental", 'Color','r') % NACA 2412 Experimental Data
plot(naca_0012.data(:,1),naca_0012.data(:,2), "DisplayName","NACA0012 Experimental", 'Color','g') % NACA 0012 Experimental Data
plot(naca_4412.data(:,1),naca_4412.data(:,2), "DisplayName","NACA2412 Experimental", 'Color','c') % NACA 4412 Experimental Data
plot(alpha, vpm_cl_2412, "DisplayName","NACA2412 Vortex Panel Menthod", 'Color','r', 'LineStyle', '--') % NACA 2412 Vortex Panel Method
plot(alpha, vpm_cl_00012, "DisplayName","NACA0012 Vortex Panel Menthod", 'Color','g', 'LineStyle', '--') % NACA 0012 Vortex Panel Method
plot(alpha, vpm_cl_4412, "DisplayName","NACA4412 Vortex Panel Menthod", 'Color','c', 'LineStyle', '--') % NACA 4412 Vortex Panel Method
plot(alpha, taf_cl_2412, "DisplayName","NACA2412 Thin Airfoil Theory", 'Color','r', 'Marker', 'o') % NACA 2412 Thin Airfoil Theory
plot(alpha, taf_cl_0012, "DisplayName","NACA0012 Thin Airfoil Theory", 'Color','g', 'Marker', 'o') % NACA 2412 Thin Airfoil Theory
plot(alpha,taf_cl_4412, "DisplayName","NACA4412 Thin Airfoil Theory", 'Color','c', 'Marker', 'o') % NACA 2412 Thin Airfoil Theory
xlabel("Angle of Attack (Degrees)")
ylabel("Lift Coefficient (cl)")
legend('Location', 'northwest')
grid on
title("Lift Distribution Comparison")
hold off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create and display a table comparing zero lift AoA and lift slope
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpha0_taf = [naca_0012_alpha0,naca_2412_alpha0,naca_4412_alpha0]'; % Thin Airfoil Theory Zero Lift AoA
alpha0_vpm = [min(alpha(vpm_cl_00012 > -0.05)),min(alpha(vpm_cl_2412 > -0.05)),min(alpha(vpm_cl_4412 > -0.05))]'; % Vortex Panel Method Zero Lift AoA
a_vpm2 = [mean(diff(vpm_cl_00012)),mean(diff(vpm_cl_2412)),mean(diff(vpm_cl_4412))]'; % Vortex Panel Method Zero Lift Slope
a_taf2 = [mean(diff(taf_cl_0012)),mean(diff(taf_cl_2412)),mean(diff(taf_cl_4412))]'; % Thin Airfoil Theory Zero Lift Slope
disp("Task 4 Results: Comparison of Zero Lift AoA and Lift Slope for Thin Airfoil Theory and Vortex Panel Method")

T = table(alpha0_taf,alpha0_vpm,a_taf2, a_vpm2,'VariableNames',["Zero Lift AoA (Thin Airfoil Theory)","Zero Lift AoA (Vortex Panel Method)", "Lift Slope (Thin Airfoil Theory)", "Lift Slope (Vortex Panel Method)"],'RowNames',["NACA0012","NACA2412","NACA4412"]);
disp(T)