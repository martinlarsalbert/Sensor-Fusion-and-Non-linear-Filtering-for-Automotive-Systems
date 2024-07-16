clear all;
close all;
clc;

clear all;
close all;
clc;

rng(42);

% Number of time steps;
N = 500;

% Define prior
x_0     = rand(5,1); 
n       = length(x_0); 
P_0     = rand(5,5);
P_0     = P_0*P_0';

% Sample time
T = 1;

% Covariance
sigV = 2;
sigOmega = 1*pi/180;
G = [zeros(2,2); 1 0; 0 0; 0 1];
Q = G*diag([sigV^2 sigOmega^2])*G';

% Motion model function handle. Note how sample time T is inserted into the function.
f = @(x) coordinatedTurnMotion(x, T);

% generate state sequence
X = genNonLinearStateSequence(x_0, P_0, f, Q, N);

%% Random sensor positions
%s1 = rand(2,1)*100;
%s2 = rand(2,1)*100;
%% Measurement model
%m=2;
%Y = zeros(m,n);
%
%for i=1:N
%    [Y(:,i),Hx] = dualBearingMeasurement(X(:,i), s1, s2);
%end;

% Random sensor position sequence
s1 = rand(2,1)*100;
s2 = rand(2,1)*100;
    
% Measurement model
h = @(x) Measurement(x);

% Measurement noise covariance
R = diag(5*rand(1,2).^2);
Y = genNonLinearMeasurementSequence(X, h, R);

type='EKF';
%x_0 = X(:,1);
%P_0 = Q;

[xf, Pf, xp, Pp] = nonLinearKalmanFilter(Y, x_0, P_0, f, Q, h, R, type);

%%
figure();
hold on;
plot(X(1,:),X(2,:),'k-');
plot(Y(1,:),Y(2,:),'r-');
plot(xf(1,:),xf(2,:),'g-');
legend('True','Mesurement',type)
xlabel('X-position px');
ylabel('Y-position py');

figure();
hold on;
plot(X(3,:));
plot(xf(3,:));
ylabel('Velocity v');

figure();
hold on;
plot(X(4,:));
plot(xf(4,:));
ylabel('Heading \phi');

figure();
hold on;
plot(X(5,:));
plot(xf(5,:));
ylabel('Turn-rate \omega');


