function [cl, alpha0] = thinAirfoil(c,m,p,N, alpha)

x = linspace(0,1,N);
alpha = alpha*pi/180;

dzdx = zeros(length(x),1);
theta = zeros(length(x),1);

for i = 1:length(x)
    theta(i) = acos(1-(2*x(i))/c);
    if x(i) >= 0 && x(i) < p*c
        dzdx(i) = (2*m/p^2) * (p - x(i)/c);
    else
        dzdx(i) = (2*m/(1-p)^2) * (p - x(i)/c);
    end
end

integrand = dzdx .* (cos(theta)-1);

alpha0 = (-1/pi)*trapz(theta, integrand);

cl = zeros(length(alpha),1);
for i = 1:length(alpha)
    cl(i) = (2*pi)*(alpha(i) - alpha0);
end


end