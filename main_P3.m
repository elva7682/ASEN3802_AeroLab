% Kaitlyn Vigil
% ASEN 3802
% Part 3
% 4/14/2026

clc; clear; close all;

%% Part 3
% NACA 2412 --> NACA 0012
Np = 100;

m_r = 2; p_r = 4; 
m_t = 0; p_t = 0;

b = 33 + 4/12; % [ft]

c_r = 5 + 4/12; % [ft]
c_t = 3 + 8.5/12; % [ft]

alpha = 4; % [deg]

[cl_r, aero_r] = ThinAirfoil(c_r,m_r,p_r,Np,alpha);
[cl_t, aero_t] = ThinAirfoil(c_t,m_t,p_t,Np,alpha);

geo_r = 5; % [deg]
geo_t = 4; % [deg]

a0_r = 0.11727*180/pi; % [rad^-1] 
a0_t = 0.11744*180/pi; % [rad^-1] % symmetric airfoil

S = c_t*b + 0.5*b*(c_r - c_t); % [ft^2]

% Determine number of of odd terms (N) for each percent error
percent_error = [0.1; 0.01; 0.001];
cl_exact = [];
for i = 1:length(percent_error)
    N_exact = 1000;
    N = 1;

    % CL Exact
    [~,c_L_exact(i),c_Di_exact(i)] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r, N_exact);
    
    % Create while loop
    c_L_error = 1;
    c_Di_error = 1;

    while c_L_error > percent_error(i)
        [~,c_L,~] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r, N);
        
        c_L_error = abs((c_L_exact(i)-c_L)/c_L_exact(i));
       
        if i == 1
            plot_c_L1(N) = c_L;
            plot_NL1 = N;
        end

        if i == 2
            plot_c_L2(N) = c_L;
            plot_NL2 = N;
        end

        if i == 3
            plot_c_L3(N) = c_L;
            plot_NL3 = N;            
        end
        N = N + 1;
    end

    N = 1;

    while c_Di_error > percent_error(i)
        [~,~,c_Di] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r, N);
        
        c_Di_error = abs((c_Di_exact(i)-c_Di)/c_Di_exact(i));
       
        if i == 1
            plot_c_Di1(N) = c_Di;
            plot_ND1 = N;
        end

        if i == 2
            plot_c_Di2(N) = c_Di;
            plot_ND2 = N;
        end

        if i == 3
            plot_c_Di3(N) = c_Di;
            plot_ND3 = N;            
        end
        N = N + 1;
    end
end

%% Deliverable 1: (Table 1)
Part3_Table1 = table(percent_error, [plot_NL1,plot_NL2,plot_NL3]', [plot_ND1,plot_ND2,plot_ND3]', ...
    [plot_c_L1(end),plot_c_L2(end),plot_c_L3(end)]',[plot_c_Di1(end),plot_c_Di2(end),plot_c_Di3(end)]'); 

Part3_Table1 = renamevars(Part3_Table1, "Var2", "NL");
Part3_Table1 = renamevars(Part3_Table1, "Var3", "ND");
Part3_Table1 = renamevars(Part3_Table1, "Var4", "C_L");
Part3_Table1 = renamevars(Part3_Table1, "Var5", "C_Di");

disp(Part3_Table1)

%% Deliverable 2: (Plots --> c_L, c_Di vs N)
figure() % c_L
hold on;
grid on;
plot(plot_c_L3, "LineWidth", 1.5)
plot(plot_c_L2, "LineWidth", 1.5)
plot(plot_c_L1, "LineWidth", 1.5)
xline(length(plot_c_L1), "--")
xline(length(plot_c_L2), "--")
xline(length(plot_c_L3), "--")
yline(c_L_exact, "r--")
xlabel("Number of Odd Terms")
ylabel("Coefficent of Lift")
title("Coefficent of Lift Based on Odd Number of Terms for Different Error Values")
legend(num2str(percent_error(3)),num2str(percent_error(2)),num2str(percent_error(1)),"10% Rel Error","1% Rel Error","0.1% Rel Error","Exact Value")

figure() % c_Di
hold on;
grid on;
plot(plot_c_Di3, "LineWidth", 1.5)
plot(plot_c_Di2, "LineWidth", 1.5)
plot(plot_c_Di1, "LineWidth", 1.5)
xline(length(plot_c_Di1), "--")
xline(length(plot_c_Di2), "--")
xline(length(plot_c_Di3), "--")
yline(c_Di_exact, "r--")
xlabel("Number of Odd Terms")
ylabel("Coefficent of Induced Drag")
title("Coefficent of Induced Drag Based on Odd Number of Terms for Different Error Values")
legend(num2str(percent_error(3)),num2str(percent_error(2)),num2str(percent_error(1)),"10% Rel Error","1% Rel Error","0.1% Rel Error","Exact Value")

%% Deliverable 3: (Table 2)
V = 100 *1.68781; % [knots --> ft/s]
h = 10000; % [ft]
rho = 1.755*10^-3; % [slugs/ft] 
c_L = plot_c_L3(end); % from previous part
c_Di = plot_c_Di3(end);

% Find cd using interpolation
% clcd_2412 = readmatrix("2412clcd.mat");
% clcd_0012 = readmatrix("0012clcd.mat");

cd_0012 = 0.0066; % digitized value
cd_2412 = 0.0075; % digitized value

cd = (cd_0012+cd_2412)/2;

L = 1/2*rho*V^2*S*c_L;
D_i = 1/2*rho*V^2*S*c_Di;
D = 1/2*rho*V^2*S*(cd+c_Di);

LD_ratio = L./D;

Part3_Table2 = table(percent_error(1), L, D_i, LD_ratio); 
Part3_Table2 = renamevars(Part3_Table2, "Var1", "percent_error");

disp(Part3_Table2)

%% Deliverable 4: (Plots --> C_D vs alpha)
alpha4 = linspace(-15,15,100);
N = 200;
for i = 1:length(alpha4)

    [cl_r, aero_r4] = ThinAirfoil(c_r,m_r,p_r,Np,alpha4(i));
    [cl_t, aero_t4] = ThinAirfoil(c_t,m_t,p_t,Np,alpha4(i));

    % Account for geometric twist
    geo_r_i = alpha4(i) + 1;
    geo_t_i = alpha4(i) + 0;

    [~,c_L4(i),c_Di4(i)] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t4, aero_r4, geo_t_i, geo_r_i, N);
end

cl0012 = load("0012.mat");
cl2412 = load("2412.mat");
dat0012 = load("0012clcd.mat");
dat2412 = load("2412clcd.mat");

CL0012 = interp1(cl0012.data(:,1), cl0012.data(:,2), alpha4, 'pchip');
CL2412 = interp1(cl2412.data(:,1), cl2412.data(:,2), alpha4, 'pchip');

CD0012 = interp1(dat0012.data(:,1), dat0012.data(:,2), CL0012, 'pchip');
CD2412 = interp1(dat2412.data(:,1), dat2412.data(:,2), CL2412, 'pchip');

CLPT5 = (CL0012+CL2412)./2;

cd4 = (CD2412 + CD0012)./2;
c_D_total = cd4 + c_Di4;

figure()
hold on;
grid on;
plot(alpha4,c_D_total, "LineWidth", 1.5)
plot(alpha4,cd4, "LineWidth", 1.5)
plot(alpha4,cd.*ones(size(alpha4)), "LineWidth", 1.5)
plot(alpha4, c_Di4, "LineWidth", 1.5)

xlabel("Angle of Attack (deg)")
ylabel("Drag Coefficient")
legend('Total Drag','Profile Drag (Changing w/\alpha)', 'Profile Drag (@ \alpha = 4)','Induced Drag')
title("Drag Breakdown Vs. Angle of Attack")

%% Deliverable 5: (Plots --> L/D vs alpha)
L5 = 1/2*rho*V^2*S*c_L4.*ones(size(alpha4));
L5_dig = 1/2*rho*V^2*S*CLPT5;

D5 = 1/2*rho*V^2*S.*(c_D_total);

LD_ratio5 = L5./D5;
LD_ratio5_dig = L5_dig./D5;

figure()
hold on;
grid on;
plot(alpha4, LD_ratio5,"LineWidth", 1.5)
plot(alpha4, LD_ratio5_dig, "LineWidth", 1.5)
xlabel("Angle of Attack (deg)")
ylabel("Lift Over Drag Ratio")
legend("PLLT", "Digitizer")
title("LD Ratio Vs. Angle of Attack")
