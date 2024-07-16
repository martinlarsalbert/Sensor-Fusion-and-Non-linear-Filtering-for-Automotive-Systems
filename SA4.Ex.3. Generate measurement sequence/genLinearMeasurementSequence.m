function Y = genLinearMeasurementSequence(X, H, R)
%GENLINEARMEASUREMENTSEQUENCE generates a sequence of observations of the state 
% sequence X using a linear measurement model. Measurement noise is assumed to be 
% zero mean and Gaussian.
%
%Input:
%   X           [n x N+1] State vector sequence. The k:th state vector is X(:,k+1)
%   H           [m x n] Measurement matrix
%   R           [m x m] Measurement noise covariance
%
%Output:
%   Y           [m x N] Measurement sequence
%

% your code here


[n,N_] = size(X);
N=N_-1;

[m,n_] = size(H);
%assert(n==n_);

Y = zeros(m,N);

mu_r = zeros(m,1);
C=chol(R);

for k=1:N
    
    r = repmat(mu_r,1,1) + (randn(1,length(mu_r))*C)';

    Y(:,k) = H*X(:,k+1) + r;
    
end