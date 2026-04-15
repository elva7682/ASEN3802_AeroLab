clc; clear; close all;
%% Part 2
% Initial Conditions
N = 50;
aero_t = 0;
aero_r = 0;
geo_t = 2;
geo_r = 2;
a0_t = 2*pi;
a0_r = 2*pi;

% Chord length
cr = 1;
ct = linspace(0.1,1,1000)';

% Aspect Ratio
AR = [4,6,8,10];

% Wingspan as a function of chord
b1 = zeros(length(ct),1);
b2 = zeros(length(ct),1);
b3 = zeros(length(ct),1);
b4 = zeros(length(ct),1);

for i = 1:length(ct)
    b1(i) = (AR(1)/2)*(cr+ct(i));
    b2(i) = (AR(2)/2)*(cr+ct(i));
    b3(i) = (AR(3)/2)*(cr+ct(i));
    b4(i) = (AR(4)/2)*(cr+ct(i));
end

% Initialize vectors
e1 = zeros(length(ct),1);
e2 = zeros(length(ct),1);
e3 = zeros(length(ct),1);
e4 = zeros(length(ct),1);
c_L1 = zeros(length(ct),1);
c_L2 = zeros(length(ct),1);
c_L3 = zeros(length(ct),1);
c_L4 = zeros(length(ct),1);
c_Di1 = zeros(length(ct),1);
c_Di2 = zeros(length(ct),1);
c_Di3 = zeros(length(ct),1);
c_Di4 = zeros(length(ct),1);

% Function calls to find e
for i = 1:length(ct)
    [e1(i), c_L1(i), c_Di1(i)] = PLLT(b1(i), a0_t, a0_r, ct(i), cr, aero_t, aero_r, geo_t, geo_r, N);
    [e2(i), c_L2(i), c_Di2(i)] = PLLT(b2(i), a0_t, a0_r, ct(i), cr, aero_t, aero_r, geo_t, geo_r, N);
    [e3(i), c_L3(i), c_Di3(i)] = PLLT(b3(i), a0_t, a0_r, ct(i), cr, aero_t, aero_r, geo_t, geo_r, N);
    [e4(i), c_L4(i), c_Di4(i)] = PLLT(b4(i), a0_t, a0_r, ct(i), cr, aero_t, aero_r, geo_t, geo_r, N);
end

% Find delta from e
del1 = (1-e1)./e1;
del2 = (1-e2)./e2;
del3 = (1-e3)./e3;
del4 = (1-e4)./e4;

% taper ratio
taper = ct./cr;


% Plot
figure(1)
hold on
grid on
plot(taper, del1, 'r', 'LineWidth',2)
plot(taper, del2, 'b', 'LineWidth',2)
plot(taper, del3, 'g', 'LineWidth',2)
plot(taper, del4, 'k', 'LineWidth',2)
ylabel('Induced Drag Factor (\delta)')
xlabel('Taper Ratio (c_t/c_r)')
title('Induced drag factor δ as a function of taper ratio')
legend('AR = 4','AR = 6','AR = 8','AR = 10')
hold off