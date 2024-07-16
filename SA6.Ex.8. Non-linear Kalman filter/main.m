clear all;
close all;
clc;

clear all;
close all;
clc;

rng(42);

% Number of time steps;
N = 100;

% Define prior
x_0     = [0,0,10,0,0]'; 
n       = length(x_0); 
%P_0     = rand(5,5);
%P_0     = P_0*P_0';
P_0     = diag([10,10,2,pi/180,pi/36]);


% Sample time
T = 1;

% Covariance
sigV = 1;
%sigV = 0.1;

sigOmega = 1*pi/180;
%sigOmega = 0.1*pi/180;


G = [zeros(2,2); 1 0; 0 0; 0 1];
Q = G*diag([sigV^2 sigOmega^2])*G';

% Motion model function handle. Note how sample time T is inserted into the function.
f = @(x) coordinatedTurnMotion(x, T);

% generate state sequence
X = genNonLinearStateSequence(x_0, P_0, f, Q, N);

%% Measurement model

% Random sensor position sequence
s1 = [-200,300]';
s2 = [-200,-300]';
    
% Measurement model
h = @(x) dualBearingMeasurement(x, s1, s2);

% Measurement noise covariance

R = diag([pi/360, pi/360].^2);  % Case 1
%R = diag([pi/18, pi/360].^2);  % Case 2


Y = genNonLinearMeasurementSequence(X, h, R);

type='UKF';
[xf, Pf, xp, Pp] = nonLinearKalmanFilter(Y, x_0, P_0, f, Q, h, R, type);

%% Check consistency
epsilon = X - xf;


%%
figure();
hold on;
plot(X(1,:),X(2,:),'k-');
%plot(Y(1,:),Y(2,:),'r-');
plot(xf(1,:),xf(2,:),'g-');

for i=1:ceil(N/10):N
    xy = sigmaEllipse2D( xf(1:2,i), Pf(1:2,1:2,i), 1, 20 );
    fill(xy(1,:),xy(2,:),'k', FaceAlpha=0.25);
end

xlabel('X-position px');
ylabel('Y-position py');

figure();
hold on;
plot(X(3,:),'k-');
plot(xf(3,:),'g-');
ylabel('Velocity v');

figure();
hold on;
plot(X(4,:),'k-');
plot(xf(4,:),'g-');
ylabel('Heading \phi');

figure();
hold on;
plot(X(5,:),'k-');
plot(xf(5,:),'g-');
ylabel('Turn-rate \omega');


