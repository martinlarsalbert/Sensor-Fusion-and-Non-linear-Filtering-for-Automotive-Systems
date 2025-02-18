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

R = diag([1, 0.0002]);
Y = [s;v] + mvnrnd(zeros(1,2),R,N)';

%%
A = [1 dt
     0 1];

%%

x_0 = [100,v(1)]';
P_0 = diag([1,0.01]);

Q = diag([0.0,0.000002]);
H = [1 0
     0 1
    ];

[X, P] = kalmanFilter(Y, x_0, P_0, A, Q, H, R);

figure();
subplot(2,1,1);
plot(t,s, 'DisplayName', 'True');
title(strcat('P_{0s}: ',num2str(P_0(1,1))));
hold on;
plot(t,Y(1,:), 'DisplayName', 'Measured');
plot(t,X(1,:), 'DisplayName', 'KF');
xlabel('time [s]')
ylabel('s [m]')
legend();

subplot(2,1,2);
plot(t,v,'DisplayName', 'True');
hold on;
plot(t,Y(2,:), 'DisplayName', 'Measured');
plot(t,X(2,:), 'DisplayName', 'KF');
xlabel('time [s]')
ylabel('v [m/s]')
%legend();

%%

x_0 = [100,v(1)]';
P_0 = diag([10000,0.01]);

Q = diag([0.0,0.000002]);
H = [1 0
     0 1
    ];

[X, P] = kalmanFilter(Y, x_0, P_0, A, Q, H, R);

figure();
subplot(2,1,1);
plot(t,s, 'DisplayName', 'True');
title(strcat('P_{0s}: ',num2str(P_0(1,1))));
hold on;
plot(t,Y(1,:), 'DisplayName', 'Measured');
plot(t,X(1,:), 'DisplayName', 'KF');
xlabel('time [s]')
ylabel('s [m]')
legend();

subplot(2,1,2);
plot(t,v,'DisplayName', 'True');
hold on;
plot(t,Y(2,:), 'DisplayName', 'Measured');
plot(t,X(2,:), 'DisplayName', 'KF');
xlabel('time [s]')
ylabel('v [m/s]')
%legend();