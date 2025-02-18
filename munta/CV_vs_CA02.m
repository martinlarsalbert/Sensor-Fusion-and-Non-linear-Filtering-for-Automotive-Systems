clear all;
close all;
clc;

N = 50;
t = linspace(0,10,N);
dt = t(end)/(N-1);

v = 1;

X = [v*t
     ones(1,N)*v
    ];

% R = 0.1;
R = diag([1,0.1]);

Y = X + mvnrnd(zeros(2,1),R,N)';

% R = diag([1, 0.0002]);


%% CV

x_0 = [0,2]';
P_0 = diag(10^-10*ones(1,2));

Q = diag([0.0,0.02]);
H = [1 0
     0 1
    ];

A = [1 dt
     0 1];


[X_CV, P_CV] = kalmanFilter(Y, x_0, P_0, A, Q, H, R);


%% CA

x_0 = [0,2,0]';
P_0 = diag(10^-10*ones(1,3));

Q = diag([0.0,0.0,0.2]);
H = [1 0 0
     0 1 0];

% A = [1 dt dt^2/2
%      0 1  dt
%      0 0  1
%     ];

A = [1 dt 0
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
plot(t,X_CA(1,:), '--', 'DisplayName', 'CA');
xlabel('time [s]')
ylabel('x [m]')
legend();

subplot(2,1,2);
plot(t,X(2,:), 'DisplayName', 'True');
hold on;
plot(t,Y(2,:), 'DisplayName', 'Measured');
plot(t,X_CV(2,:), 'DisplayName', 'CV');
plot(t,X_CA(2,:), '--', 'DisplayName', 'CA');
xlabel('time [s]')
ylabel('v [m/s]')
legend();