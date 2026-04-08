
clc
clear
close all





%% Task 1
c = 1;
N = 50;
m = 0;
p = 0;
t = 12;

[x, y,yt,yc] = NACA_Airfoils(m,p,t,c,N);




%% Task 3

% Plot predicted cl over a range of alpha for each 
naca_0006 = load("0006.mat");
naca_0012 = load("0012.mat");
