clear all;
close all;
clc;

% Tolerance

tol = 1e-5;

% General parameters
N = 10;
n = 1;
T = 1;

% Motion Parameters
A = 1;
Q = T*.5^2;

% Measurement Parameters
H = 1;
R = 1^2;

% Prior
xPrior  = 0;
PPrior  = 2^2;

% genereate measurement sequence
measuremetnSequence = 10*ones(1,N);

% Filter
[stateSequence, covarianceSequence] = kalmanFilter(measuremetnSequence, xPrior, PPrior, A, Q, H, R);

%%

figure(1); clf; hold on;
plot([1:N], measuremetnSequence, '*r');

plot([0:N], [xPrior stateSequence], 'b');
plot([0:N], [xPrior stateSequence] + 3*sqrt([PPrior covarianceSequence(:)']), '--b');
plot([0:N], [xPrior stateSequence] - 3*sqrt([PPrior covarianceSequence(:)']), '--b');

title('Your solution')
xlabel('k');
ylabel('x');
legend('measurements', 'state estimate', '+3-sigma level', '-3-sigma level','Location','southeast');
