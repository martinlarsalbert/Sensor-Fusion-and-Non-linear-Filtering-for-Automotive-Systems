close all;
clear all;
clc;

% Common data

% Tolerance
tol = 1e-1;

N = 5000;

% Define prior
x_0     = [0]; 
n       = length(x_0); 
P_0     = 100*diag(ones(n,1));

% Define process model
A       = diag(ones(n,1));
Q       = diag(ones(n,1));

% generate state sequence
s = rng;
X   = genLinearStateSequence(x_0, P_0, A, Q, N);

%%
% Plot results
figure(1);
hold on;
plot(X);
title('Your solution');
xlabel('k');
ylabel('x');