
clc
clear
close all



%% Task 1

[x_0021, y_0021, yc_0021] = NACA_Airfoils(0,0,21,1,50);


figure
hold on
plot(x_0021,y_0021, "-o")
xlim([0,1])
ylim([-0.5,0.5])
title("NACA0021 Airfoil")
xlabel("x position (% chord)")
ylabel("y position (% chord)")
grid on
hold off

[x_2421, y_2421, yc_2421] = NACA_Airfoils(2,4,21,1,50);


figure
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

alpha = -16:1:20;

% Calculate 0 Lift angle of attack
[cl6, naca_0006_alpha0] = thinAirfoil(1,0,0,N, alpha);
[cl12, naca_0012_alpha0] = thinAirfoil(1,0,0,N, alpha);
[cl18,naca_0018_alpha0] = thinAirfoil(1,0,0,N, alpha);




% Calculate Airfoil Shape
[x_0006, y_0006, yc_0006] = NACA_Airfoils(0,0,6,1,N);
[x_0012, y_0012, yc_0012] = NACA_Airfoils(0,0,12,1,N);
[x_0018, y_0018, yc_0018] = NACA_Airfoils(0,0,18,1,N);

naca_0006_calc = zeros(size(alpha));
naca_0012_calc = zeros(size(alpha));
naca_0018_calc = zeros(size(alpha));


for i = 1:length(alpha)
    naca_0006_calc(i) = Vortex_Panel(x_0006,y_0006,alpha(i));
    naca_0012_calc(i) = Vortex_Panel(x_0012,y_0012,alpha(i));
    naca_0018_calc(i) = Vortex_Panel(x_0018,y_0018,alpha(i));
end

% Load in experimental data
naca_0006 = load("0006.mat");
naca_0012 = load("0012.mat");


% Plot predicted cl over a range of alpha for each 

figure
hold on
plot(naca_0006.data(:,1),naca_0006.data(:,2), "DisplayName","NACA0006 Experimental", 'Color','r')
plot(naca_0012.data(:,1),naca_0012.data(:,2), "DisplayName","NACA0012 Experimental", 'Color','y')
plot(alpha, naca_0006_calc, "DisplayName","NACA0006 Predicted", 'Color','r', 'LineStyle', '--')
plot(alpha, naca_0012_calc, "DisplayName","NACA0012 Predicted", 'Color','y', 'LineStyle', '--')
plot(alpha, naca_0018_calc, "DisplayName","NACA0018 Predicted", 'Color','c', 'LineStyle', '--')
legend('Location', 'northwest')
title("Lift Distribution Comparison")
xlabel("Angle of Attack (Degrees)")
ylabel("Lift Coefficient (cl)")
grid on
hold off


alpha0_predicted = [naca_0006_alpha0,naca_0012_alpha0,naca_0018_alpha0]';
alpha0_experimental = [0,0,0]';
cl_predicted = [1,1,1]';
cl_experimental = [2,2,2]';
airfoils = ["NACA006", "NACA0012", "NACA0018"];
labels = ["Predicted alpha _0", "Experimental alpha_0", "Predicted Lift Slope", "Experimental Lift Slope"];
T = table(alpha0_predicted,alpha0_experimental,cl_predicted,cl_experimental,'RowNames',airfoils, 'VariableNames', labels)



%% Task 4

% Load in experimental data
naca_2412 = load("2412.mat");
naca_4412 = load("4412.mat");


% Calculate 0 Lift angle of attack
[cl2412, naca_2412_alpha0] = thinAirfoil(1,2,4,N, alpha);
[cl4412,naca_4412_alpha0] = thinAirfoil(1,2,4,N, alpha);



% Calculate Airfoil Shape
[x_2412, y_2412, yc_2412] = NACA_Airfoils(2,4,12,1,N);
[x_4412, y_4412, yc_4412] = NACA_Airfoils(2,4,12,1,N);

naca_2412_calc = zeros(size(alpha));
naca_4412_calc = zeros(size(alpha));


for i = 1:length(alpha)
    naca_2412_calc(i) = Vortex_Panel(x_2412,y_2412,alpha(i));
    naca_4412_calc(i) = Vortex_Panel(x_4412,y_4412,alpha(i));
end



% Plot predicted cl over a range of alpha for each 

figure
hold on
plot(naca_2412.data(:,1),naca_2412.data(:,2), "DisplayName","NACA2412 Experimental", 'Color','r')
plot(naca_0012.data(:,1),naca_0012.data(:,2), "DisplayName","NACA0012 Experimental", 'Color','y')
plot(naca_4412.data(:,1),naca_4412.data(:,2), "DisplayName","NACA2412 Experimental", 'Color','c')
plot(alpha, naca_2412_calc, "DisplayName","NACA2412 Predicted", 'Color','r', 'LineStyle', '--')
plot(alpha, naca_0012_calc, "DisplayName","NACA0012 Predicted", 'Color','y', 'LineStyle', '--')
plot(alpha, naca_4412_calc, "DisplayName","NACA4412 Predicted", 'Color','c', 'LineStyle', '--')
xlabel("Angle of Attack (Degrees)")
ylabel("Lift Coefficient (cl)")
legend('Location', 'northwest')
grid on
title("Lift Distribution Comparison")
hold off


alpha0_predicted = [naca_0012_alpha0,naca_2412_alpha0,naca_4412_alpha0]';
alpha0_experimental = [0,0,0]';
cl_predicted = [1,1,1]';
cl_experimental = [2,2,2]';
airfoils = ["NACA2012", "NACA2412", "NACA4412"];
labels = ["Predicted alpha _0", "Experimental alpha_0", "Predicted Lift Slope", "Experimental Lift Slope"];
T = table(alpha0_predicted,alpha0_experimental,cl_predicted,cl_experimental,'RowNames',airfoils, 'VariableNames', labels)