function [x_b,y_b, yc] = NACA_Airfoils(m,p,t,c,n)

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

yt = zeros(1,length(x));
yc = zeros(1,length(x));
dyc = zeros(1,length(x));

for i=1:length(x)
    yt(i) = (t/0.2) * c * (0.2969 * sqrt(x(i)/c) - 0.1260 * (x(i)/c) - 0.3516 * (x(i)/c).^2 + 0.2843 * (x(i)/c).^3 - 0.1036 * (x(i)/c).^4);


if x(i) < p*c
    yc(i) = (m * (x(i)/p^2)) .* (2*p - (x(i)/c));
    dyc(i) = ((2*m/(p^2)) * (p - (x(i)/c)));
elseif x(i)<=c
    yc(i) = (m*(c-x(i))/((1-p)^2))*(1 + x(i)/c - 2*p);
    dyc(i) = ((2 * m) / (1 - p)^2) * (p - (x(i)/c));
else
    disp("oopsies!!")
end

end

xi  = zeros(1, length(x));

for i=1:length(x)
    xi(i) = atan(dyc(i));
end


yu = zeros(1, length(x_u));
yl = zeros(1, length(x_l));

ycu = yc(theta <= pi);
ycl = yc(theta > pi);

ytu = yt(theta <= pi);
ytl = yt(theta > pi);

xiu = xi(theta <= pi);
xil = xi(theta > pi);

for i=1:length(x_u)
    yu(i) = ycu(i) + ytu(i) * cos(xiu(i));
end

for i=1:length(x_l)
    yl(i) = ycl(i) - ytl(i) * cos(xil(i));
end

% yu = ycu + ytu + cos(xiu);
% yl = ycl + ytl + cos(xil);



x_b = [x_l, x_u];
y_b = [yl, yu];



end