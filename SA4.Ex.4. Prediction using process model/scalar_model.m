tol = 1e-5;


n = 1;
T = 1;

% Motion Parameters
A = 2;
Q = T*1;

% Prior
xPrior  = mvnrnd(zeros(n,1)', diag(ones(n)))';
V       = rand(n,n);
PPrior  = V*diag(rand(n,1))*V';

[xPred, PPred] = linearPrediction(xPrior, PPrior, A, Q);