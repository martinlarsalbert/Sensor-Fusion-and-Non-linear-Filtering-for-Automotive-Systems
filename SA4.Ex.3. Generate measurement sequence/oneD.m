absTol = 1e-1;
relTol = 5e-2;

N = 50000;

n = randi(1,1);
m = randi(n,1);

% Define state sequence
X = zeros(n,N+1);

% Define measurement model
H = 1;
R = .5^2;

% Generate measurements
Y = genLinearMeasurementSequence(X, H, R);

% PLot results
figure(1);clf;hold on;
plot(0:10,X(1,1:11), '--k');
plot(1:10, Y(1,1:10), '*r');
legend('State sequence', 'Measurements')
title('Your solution');
xlabel('k');
ylabel('position');

assert(size(Y,1) == m, 'Y has the wrong measurement dimension');
assert(size(Y,2) == N, 'Y should have N columns');

Rest = cov((Y-H*X(:, 2:N+1))');
assert(all(all((mean(Y-H*X(:, 2:N+1)) < absTol))), 'Measurement noise is not zeros mean');
assert(all(all((abs(Rest-R) < relTol*R))), 'Measurement noise covariance is not within tolerances');