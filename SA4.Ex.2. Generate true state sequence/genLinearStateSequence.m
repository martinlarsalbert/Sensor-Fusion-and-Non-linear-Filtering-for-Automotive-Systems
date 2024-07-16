function X = genLinearStateSequence(x_0, P_0, A, Q, N)
%GENLINEARSTATESEQUENCE generates an N-long sequence of states using a 
%    Gaussian prior and a linear Gaussian process model
%
%Input:
%   x_0         [n x 1] Prior mean
%   P_0         [n x n] Prior covariance
%   A           [n x n] State transition matrix
%   Q           [n x n] Process noise covariance
%   N           [1 x 1] Number of states to generate
%
%Output:
%   X           [n x N+1] State vector sequence
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_states = length(x_0);
X = zeros(n_states,N+1);
%X(:,1) = x_0;


R=chol(P_0);
mu_r = zeros(n_states,1);
r = mu_r + (randn(1,length(mu_r))*R)';
X(:,1) = x_0 + r;

mu_q = zeros(n_states,1);

R=chol(Q);

for k=2:N+1
    q = mu_q + (randn(1,length(mu_q))*R)';
    X(:,k) = A*X(:,k-1) + q;
    
end