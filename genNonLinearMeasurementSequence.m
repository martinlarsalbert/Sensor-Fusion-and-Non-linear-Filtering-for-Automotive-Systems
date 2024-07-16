function Y = genNonLinearMeasurementSequence(X, h, R)
%GENNONLINEARMEASUREMENTSEQUENCE generates ovservations of the states 
% sequence X using a non-linear measurement model.
%
%Input:
%   X           [n x N+1] State vector sequence
%   h           Measurement model function handle
%               [hx,Hx]=h(x) 
%               Takes as input x (state) 
%               Returns hx and Hx, measurement model and Jacobian evaluated at x
%   R           [m x m] Measurement noise covariance
%
%Output:
%   Y           [m x N] Measurement sequence
%

% Your code here

[n,N_] = size(X);
N=N_-1;
[m,n_] = size(R);

Y = zeros(m,N);
mu_r = zeros(m,1);

for k=1:N
    
    r = mvnrnd(mu_r,R)';
    x = X(:,k+1);
    [hx, Hx] = h(x);
    Y(:,k) = hx + r;
    
end

end