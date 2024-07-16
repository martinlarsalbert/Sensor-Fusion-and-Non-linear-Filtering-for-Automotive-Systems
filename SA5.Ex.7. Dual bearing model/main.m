clear all;
close all;
clc;

% Random state
x = mvnrnd([0 0 0 0],diag([100 100 100 10*pi/180].^2))';
% Random sensor positions
s1 = rand(2,1)*100;
s2 = rand(2,1)*100;
% Measurement model
[hx,Hx] = dualBearingMeasurement(x, s1, s2);
