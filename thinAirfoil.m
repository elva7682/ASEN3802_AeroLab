function [alpha] = thinAirfoil(c,m,p,N)

x = linspace(0,1,N);

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

alpha = (-1/pi)*trapz(theta, integrand);

end