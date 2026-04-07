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
