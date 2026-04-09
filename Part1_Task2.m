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
plot_cl = [];
plot_N = [];


while cl_error > 0.01
    N = N + 1;
    [x_b, y_b] = NACA_Airfoils(m,p,t,c,N);
    
    cl = Vortex_Panel(x_b, y_b, alpha);
    cl_error = abs((cl_exact-cl)/cl_exact);
    
    plot_cl(N) = cl;
    plot_N(N) = N;
end

fprintf('Exact cl: %.6f\n', cl_exact);
fprintf('Final cl: %.6f\n', cl);
fprintf('Number of panels N: %d\n', N);

% Convergence Plot
figure(1)
plot(plot_N,plot_cl, "b")
yline(cl_exact, "r")
xline(N, "--")
xlabel("Number of Panels")
ylabel("Predicted Sectional Coefficient of Lift")
title("Convergence Plot of the Predicted Sectional Lift Coefficient")
legend("Convergence Line", "Exact Solution", "Minimum Number of Panels")

% Table Comparison
Comp_Table = table([cl;cl_exact], [N;N_exact], [cl_error;0]);
Comp_Table = renamevars(Comp_Table, "Var1", "Cl");
Comp_Table = renamevars(Comp_Table, "Var2", "N");
Comp_Table = renamevars(Comp_Table, "Var3", "Cl Error");
