function [x_b,y_b, yc] = NACA_Airfoils(m,p,t,c,N)
% NACA_Airfoils creates coordinates points to describe airfoil shape 
% Creates a set of N+1 x and y coordinate pairs tracing the surface of a
% NACA 4-digit airfoil
%
% Author: Samuel Meyen
% Collaborators: Elisabeth van Reijendam
% Date: 4/8/2026
%
% INPUTS:
%   m: max camber in % chord
%   p: x-location of max camber in 1/10th chord
%   t: max thickness in % chord
%   c: chord length
%   N: number of panels
%
% OUTPUTS:
%   x_b: x coordinates of airfoil surface arranged from TE to LE
%   y_b: y coordinates of airfoil surface arranged from TE to LE
%   yc: y coordinates of airfoil camber line arranged from TE to LE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rescale airfoil properties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = m/100;
p = p/10;
t = t/100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create an vector of x-coordinates using equiangular spacing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d_theta = 2*pi/N; %spacing between each angle based for N panels
theta = flip(0:d_theta:2*pi); %array of equidistant angles

x = (c/2)*cos(theta) + (c/2)*ones(size(theta)); %vector of equiangular x coordinates
x_u = x(theta <= pi); %vector of x coordinates along the upper surface
x_l = x(theta > pi);%vector of x coordinates along the lower surface


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preallocate vectors for thickness, camber, and slope
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

yt = zeros(1,length(x)); %thickness distribution of the airfoil normal to the mean camber line
yc = zeros(1,length(x)); %y coordinates of the camber line
dyc = zeros(1,length(x)); %slope of the camber line


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the associated thickness, camber, slope, and local angle for each x coordinate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(x) % loop across each x coordinate
    yt(i) = (t/0.2) * c * (0.2969 * sqrt(x(i)/c) - 0.1260 * (x(i)/c) - 0.3516 * (x(i)/c).^2 + 0.2843 * (x(i)/c).^3 - 0.1036 * (x(i)/c).^4); %airfoil thickness equation

    % calculate y coordinate of camber and camber slope

    if x(i) < p*c
        yc(i) = (m * (x(i)/p^2)) .* (2*p - (x(i)/c)); % camber y-coordinate
        dyc(i) = ((2*m/(p^2)) * (p - (x(i)/c))); % camber slope
    elseif x(i)<=c
        yc(i) = (m*(c-x(i))/((1-p)^2))*(1 + x(i)/c - 2*p); % camber y-coordinate
        dyc(i) = ((2 * m) / (1 - p)^2) * (p - (x(i)/c)); % camber slope
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate Local Angle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xi  = zeros(1, length(x)); % preallocate vector for local angle

for i=1:length(x)
    xi(i) = atan(dyc(i));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate y coordinates of airfoil surface
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Preallocate vectors for the upper and lower surface y coordinates
yu = zeros(1, length(x_u));
yl = zeros(1, length(x_l));

% Separate out the upper and lower surface camber y coordinates
ycu = yc(theta <= pi);
ycl = yc(theta > pi);

% Separate out the upper and lower surface thickness values
ytu = yt(theta <= pi);
ytl = yt(theta > pi);

% Separate out the upper and lower surface local angles
xiu = xi(theta <= pi);
xil = xi(theta > pi);

% Calculate upper surface y coordinates
for i=1:length(x_u)
    yu(i) = ycu(i) + ytu(i) * cos(xiu(i));
end

% Calculate lower surface y coordinates
for i=1:length(x_l)
    yl(i) = ycl(i) - ytl(i) * cos(xil(i));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combine Upper and Lower coordinate vectors into a a single x and single y
% vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_b = [x_l, x_u];
y_b = [yl, yu];


end