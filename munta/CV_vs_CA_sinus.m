clear all;
close all;
clc;

N = 50;
t = linspace(0,10,N);
dt = t(end)/(N-1);
X = [sin(t)
     cos(t)
    ];

R = 0.002;
Y = X(1,:) + mvnrnd(zeros(1,1),R,N)';

% R = diag([1, 0.0002]);


%% CV

x_0 = [0,1]';
P_0 = diag([1,0.01]);

Q = diag([0.0,0.000002]);
H = [1 0];

A = [1 dt
     0 1];


[X_CV, P_CV] = kalmanFilter(Y, x_0, P_0, A, Q, H, R);


%% CV

x_0 = [0,1,0]';
P_0 = diag([1,0.01,0.01]);

Q = diag([0.0,0.0,0.000002]);
H = [1 0 0];

A = [1 dt dt^2/2
     0 1  dt
     0 0  1
    ];


[X_CA, P_CA] = kalmanFilter(Y, x_0, P_0, A, Q, H, R);


%%

figure();
subplot(2,1,1);
plot(t,X(1,:), 'DisplayName', 'True');
hold on;
plot(t,Y(1,:), 'DisplayName', 'Measured');
plot(t,X_CV(1,:), 'DisplayName', 'CV');
plot(t,X_CA(1,:), 'DisplayName', 'CA');
xlabel('time [s]')
ylabel('x [m]')
legend();

subplot(2,1,2);
plot(t,X(2,:), 'DisplayName', 'True');
hold on;
% plot(t,Y(2,:), 'DisplayName', 'Measured');
plot(t,X_CV(2,:), 'DisplayName', 'CV');
plot(t,X_CA(2,:), 'DisplayName', 'CA');
xlabel('time [s]')
ylabel('v [m/s]')
legend();