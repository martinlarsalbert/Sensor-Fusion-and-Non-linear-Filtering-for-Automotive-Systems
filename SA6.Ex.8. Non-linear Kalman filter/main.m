clear all;
close all;
clc;

clear all;
close all;
clc;

rng(42);

% Number of time steps;
N = 200;

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

%% Check consistency (SA6.12)
n0 = 10; % We assume a time n where the influence from the prior is small enough to be safely ignored.
NNs = 4*n0:ceil(N/10):N;
E_epsilons = zeros(n,length(NNs));
for i = 1:length(NNs)
    NN = NNs(i);
    epsilons = X(:,n0+1:NN+1) - xf(:,n0:NN);
    E_epsilons(:,i) = sum(epsilons,2)/(NN-n0);
end;
figure();
plot(E_epsilons);
title("The mean value of the error $\epsilon \rightarrow 0$ when $N \rightarrow \infty$", 'Interpreter','latex');

% Collect many short sequences. Plot a histogram* of all  for a certain fixed time . 
% Plot density , and compare the two. 
% This will work also when , despite  varying within a sequence, 
% since we know that  for a fixed time  will be the same in all sequences.

% > I don't understand how to do this..?
%Alternative 2 is false: In the nonlinear case, P_k varies over time, but not only because of time varying Q_k and R_k. 
% In this case we assumed those to be constant, and yet we get a varying posterior covariance. 
% The variations in posterior covariance come from the dependence on the state through the different linearization points, and is thus not same for all sequences anymore.

% Collect one long sequence, cut off the first  samples. 
% Then compare histogram of  for all  to the density .
figure();
hold on;
epsilons = X(:,n0+1:NN+1) - xf(:,n0:NN);
histogram(epsilons(1,:),30, 'Normalization','probability');
x = linspace(-15,15,100);
sigma = sqrt(Pf(1,1,n0));
y = pdf('Normal',x,0,sigma);
plot(x,y);
% Alternative 3 is false: In the nonlinear case, P_k does not converge to a constant covariance matrix, and thus we can not use ensemble averaging.

% Plot histogram of epsilon'*inv(P_k)*epsilon and compare to density p(x) = xi^2(x;5), in this 5-dimensional problem.
xs = zeros(1,N-n0);
for i=n0:N
    epsilon = X(:,i+1) - xf(:,i);
    xs(i) = epsilon'*inv(Pf(:,:,i))*epsilon;
end;
figure();
hold on;
histogram(xs,30, 'Normalization','probability');
x = linspace(0,15,100);
y = pdf('chi2',x,5);
plot(x,y);

%SA6.Ex.13. The last option of comparing to the  density squishes all states into one variable. 
% Another, but very similar, idea when we have access to the true state, is to normalise each estimation error epsilon_k, 
% by the square root of its estimated covariance to get a new variable 
% Ideally this new variable should be standard Gaussian distributed, i.e. .
zetas = zeros(n,N);
for i=1:N
    epsilon = X(:,i+1) - xf(:,i);
    zetas(:,i) = inv(sqrtm(Pf(:,:,i)))*epsilon;  % zeta ~ N(0,I).
end;
E_zeta = sum(zetas,2)/N;
reasonable_treshold = 3/sqrt(N);
assert(all(abs(E_zeta) < reasonable_treshold));

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


