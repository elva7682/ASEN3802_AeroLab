function [e, c_L, c_Di] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r, N)
    %% Initial Variables
    % Assume symmetric
    
    %% Initialize Theta0
    % Square Matrix
    M = N;
    
    T0 = zeros(N,1);
    for i = 1:N
        T0(i) = (i*pi)/(2*N);
    end

    %% Find a0, a, liftslope as a function of theta
    a0 = zeros(N,1);
    a = zeros(N,1);
    liftslope = zeros(N,1);
    for i = 1:N
        y = -(b/2)*cos(T0(i));
    
        if T0(i) < pi/2 && T0(i) > 0
            a0(i) = aero_r + (aero_r-aero_t)*(y/(b/2));
            a(i) = geo_r + (geo_r-geo_t)*(y/(b/2));
            liftslope(i) = a0_r + (a0_r-a0_t)*(y/(b/2));
        elseif T0(i) < pi && T0(i) > pi/2
            a0(i) = aero_r + (aero_t-aero_r)*(y/(b/2));
            a(i) = geo_r + (geo_t-geo_r)*(y/(b/2));
            liftslope(i) = a0_r + (a0_t-a0_r)*(y/(b/2));
        elseif T0(i) == pi || T0(i) == 0
            a0(i) = aero_t;
            a(i) = geo_t;
            liftslope(i) = a0_t;
        elseif T0(i) == pi/2
            a0(i) = aero_r;
            a(i) = geo_r;
            liftslope(i) = a0_r;
        end

    end

    %% Calculate c as a funciton of Theta
    
    c = zeros(length(T0),1);
    
    for i = 1:length(T0)
        y = -(b/2)*cos(T0(i));
    
        if T0(i) < pi/2 && T0(i) > 0
            c(i) = c_r + (c_r-c_t)*(y/(b/2));
        elseif T0(i) < pi && T0(i) > pi/2
            c(i) = c_r + (c_t-c_r)*(y/(b/2));
        elseif T0(i) == pi || T0(i) == 0
            c(i) = c_t;
        elseif T0(i) == pi/2
            c(i) = c_r;
        end
    end
    
    %% Use nested for loops to create equations
    % initialize equation matix
    EQA = zeros(M,N);
    
    for i = 1:M
        for j = 1:N
    
            EQA(i,j) = ((4*b)/(liftslope(i)*c(i)))*sin((2*j - 1)*T0(i)) ...
                + (2*j-1)*(sin((2*j-1)*T0(i))/sin(T0(i)));
    
        end
    end
    
    %% Evaluate A1, A3, ... , AN
    RHS = (a-a0);
    
    A = EQA\RHS;
    
    %% Evaluate Span Efficiency Factor
    
    Del = 0;
    for i = 2:N
        Del = Del + (2*i-1) * ((A(i)/A(1))^2);
    end
    
    e = 1/(1+Del);

    %% Coefficient of Lift

    S = c_t*b + b*(c_r - c_t);

    AR = (b^2)/S;

    c_L = A(1)*pi*AR;

    c_Di = (c_L^2)/(pi*e*AR);


end