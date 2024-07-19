function X = genNonLinearStateSequence(x_0, P_0, f, Q, N)
%GENLINEARSTATESEQUENCE generates an N+1-long sequence of states using a 
%    Gaussian prior and a linear Gaussian process model
%
%Input:
%   x_0         [n x 1] Prior mean
%   P_0         [n x n] Prior covariance
%   f           Motion model function handle
%               [fx,Fx]=f(x) 
%               Takes as input x (state), 
%               Returns fx and Fx, motion model and Jacobian evaluated at x
%               All other model parameters, such as sample time T,
%               must be included in the function
%   Q           [n x n] Process noise covariance
%   N           [1 x 1] Number of states to generate
%
%Output:
%   X           [n x N+1] State vector sequence
%

% Your code here

n_states = length(x_0);
X = zeros(n_states,N+1);

mu_q = zeros(n_states,1);

qs = zeros(n_states,N+1);

q = mvnrnd(mu_q,Q)';
qs(:,1) = q; % Saving the random...

X(:,1) = x_0 + q;

for k=2:N+1
    q = mvnrnd(mu_q,Q)';
    qs(:,k-1) = q; % Saving the random...

    x = X(:,k-1);
    [fx,A] = f(x);
    
    X(:,k) = fx + q;
    
end

end