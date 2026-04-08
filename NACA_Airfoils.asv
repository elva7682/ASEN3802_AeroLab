function [x_b,y_b,yt, yc] = NACA_Airfoils(m,p,t,c,n)

arguments (Input)
    m
    p
    t
    c
    n
end

arguments (Output)
    x_b
    y_b
    yt
    yc
end

% m  max camber, in % of chord
% p  location of max camber, in % of chord * 10
% t  max thickness, in % of chord

m = m/100;
p = p/10;
t = t/100;

% Equivalent Angles
d_theta = 2*pi/n;
theta = flip(0:d_theta:2*pi);
% At this stage, the x values go from TE around CW
x = (c/2)*cos(theta) + (c/2)*ones(size(theta));
x_u = x(theta <= pi);
x_l = x(theta > pi);
% At the end of calculations recombine as x = [x_l, x_u] to maintain CW
% from TE

% x = linspace(0, c, n); % panel locations vector

yt = zeros(1,length(x_u));
yc = zeros(1,length(x_u));
dyc = zeros(1,length(x_u));

for i=1:length(x_u)
    yt(i) = (t/0.2) * c * (0.2969 * sqrt(x_u(i)/c) - 0.1260 * (x_u(i)/c) - 0.3516 * (x_u(i)/c).^2 + 0.2843 * (x_u(i)/c).^3 - 0.1036 * (x_u(i)/c).^4);


if x_u < p*c
    yc(i) = (m * (x_u(i)/p^2)) .* (2*p - (x_u(i)/c));
    dyc(i) = ((2*m/(p^2)) * (p - (x_u(i)/c)));
elseif x<=c
    yc(i) = (m*(c-x_u(i))/((1-p)^2))*(1 + x_u(i)/c - 2*p)
    dyc(i) = ((2 * m) / (1 - p)^2) * (p - (x_u(i)/c));
else
    disp("oopsies!!")
end

end

xi  = zeros(1, length(x_u));

for i=1:length(x_u)
    xi(i) = atan(dyc(i));
end


xl = zeros(1, length(x_l));
yl = zeros(1, length(x_l));

for i=1:length(x_u)
    yu(i) = yc(i) + yt(i) * cos(xi(i));
end

for i=1:length(x_l)
    yl(i) = yc(i) - yt(i) * cos(xi(i));
end


x_b = [x_l, x_u];
y_b = [yl, yu];


figure
hold on
scatter(x_b,y_b)
xlim([0,1])
ylim([0,1])
plot(x_u,yt, 'Color', 'r')
plot(x_u,yc, 'Color', 'm')


end