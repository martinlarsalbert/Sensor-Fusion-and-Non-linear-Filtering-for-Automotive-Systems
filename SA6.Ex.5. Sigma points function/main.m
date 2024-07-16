clear all;
close all;
clc;

% Random state dimension
%n = ceil(rand*10);
n = 3;
% random mean
x = rand(n,1);
% random covariance
P = rand(n,n);
P = P*P';

% UKF
[SP,W] = sigmaPoints(x, P, 'UKF');

% CKF
[SP,W] = sigmaPoints(x, P, 'CKF');