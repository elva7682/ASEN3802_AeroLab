function [cl, alpha0] = ThinAirfoil(c,m,p,N,alpha)
% ThinAirfoil determines lift slope and zero lift angle of attack 
% Uses Thin Airfoil Theory to calculate the lift coefficient and zero lift
% angle of attack for a given NACA 4-digit airfoil
%
% Author: Brady Hormouth
% Date: 4/8/2026
%
% INPUTS:
%   c: chord length
%   m: max camber in % chord
%   p: x-location of max camber in 1/10th chord
%   N: number of panels
%   alpha: angle of attack in degrees
%
% OUTPUTS:
%   cl: lift coefficient
%   alpha0: zero lift angle of attack


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rescale airfoil properties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = m/100;
p = p/10;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create an vector of x-coordinates using equiangular spacing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d_theta = 2*pi/N; %spacing between each angle based for N panels
theta = flip(0:d_theta:pi); %array of equidistant angles
x = (c/2)*cos(theta) + (c/2)*ones(size(theta)); %vector of equiangular x coordinates


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert angle of attack to radians
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha = alpha*pi/180;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preallocate vectors for camberline slope and anlge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dzdx = zeros(length(x),1); % camberline slope
theta = zeros(length(x),1); % angle


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate zero lift angle of attack
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculate camberline slope
for i = 1:length(x)
    theta(i) = acos(1-(2*x(i))/c);
    if x(i) >= 0 && x(i) < p*c
        dzdx(i) = (2*m/p^2) * (p - x(i)/c);
    else
        dzdx(i) = (2*m/(1-p)^2) * (p - x(i)/c);
    end
end

% integrand of the thin airfoil theory function to calculate zero lift AoA
integrand = dzdx .* (cos(theta)-1);

alpha0 = (-1/pi)*trapz(theta, integrand); % zero lift angle of attack


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate lift coefficient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cl = zeros(length(alpha),1);
for i = 1:length(alpha)
    cl(i) = (2*pi)*(alpha(i) - alpha0);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert zero lift angle of attack to degrees
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha0 = alpha0*180/pi;

end