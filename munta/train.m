clear all;
close all;
clc;

L = 10; % [m]
N = 50;
t = linspace(0,10,N);
dt = t(end)/(N-1);
v = ones(1,N)*L/t(end);  % [m/s]
s0 = 2;
s = s0 + v.*t;

R = diag([0.0002]);
Y = v + mvnrnd(0,R,N)';


%%

x_0 = [0,v(1)]';
P_0 = diag([0.1,0.01]);

A = [1 dt
     0 1];
Q = diag([0.0,0.00002]);
H = [0 1];

[X, P] = kalmanFilter(Y, x_0, P_0, A, Q, H, R);


%%
figure();
subplot(2,1,1);
plot(t,s, 'DisplayName', 'True');
title('Only velocity measurements');
hold on;
plot(t,X(1,:), 'DisplayName', 'KF');
xlabel('time [s]')
ylabel('s [m]')
legend();

subplot(2,1,2);
plot(t,v,'DisplayName', 'True');
hold on;
plot(t,Y(1,:), 'DisplayName', 'Measured');
plot(t,X(2,:), 'DisplayName', 'KF');
xlabel('time [s]')
ylabel('v [m/s]')
%legend();