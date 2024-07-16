clear all;
close all;
clc;

% Number of states
N = 1000;


% Random sensor position sequence
s1 = [-1, 0]';
s2 = [1, 0]';

% Measurement noise covariance
R = diag([pi/50 pi/50].^2);

% Measurement model
measModel = @(X) dualBearingMeasurement(X, s1, s2);

% Position sequence
position = [2; 0.2];
X = repmat(position,1,N);


% Generate measurements
Y = genNonLinearMeasurementSequence(X, measModel, R);


%%
[x_p, y_p] = pseudoMeasurement(Y, s1,s2);

Sigma_pseudo = cov(x_p,y_p)
mu_pseudo = [mean(x_p);mean(y_p)];
elipse_sigma1 = sigmaEllipse2D(mu_pseudo, Sigma_pseudo, 1, 50);

figure();
hold on;
plot(x_p,y_p, 'b.');
plot(elipse_sigma1(1,:),elipse_sigma1(2,:), 'k-');
plot(position(1),position(2), 'sr', 'MarkerSize',8, 'LineWidth',2);
plot(mu_pseudo(1),mu_pseudo(2), 'ok', 'MarkerSize',8, 'LineWidth',2);