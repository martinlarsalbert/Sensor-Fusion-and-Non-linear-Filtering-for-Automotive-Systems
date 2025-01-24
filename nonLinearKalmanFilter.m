function [xf, Pf, xp, Pp] = nonLinearKalmanFilter(Y, x_0, P_0, f, Q, h, R, type)
%NONLINEARKALMANFILTER Filters measurement sequence Y using a 
% non-linear Kalman filter. 
%
%Input:
%   Y           [m x N] Measurement sequence for times 1,...,N
%   x_0         [n x 1] Prior mean for time 0
%   P_0         [n x n] Prior covariance
%   f                   Motion model function handle
%                       [fx,Fx]=f(x) 
%                       Takes as input x (state) 
%                       Returns fx and Fx, motion model and Jacobian evaluated at x
%   Q           [n x n] Process noise covariance
%   h                   Measurement model function handle
%                       [hx,Hx]=h(x,T) 
%                       Takes as input x (state), 
%                       Returns hx and Hx, measurement model and Jacobian evaluated at x
%   R           [m x m] Measurement noise covariance
%
%Output:
%   xf          [n x N]     Filtered estimates for times 1,...,N
%   Pf          [n x n x N] Filter error convariance
%   xp          [n x N]     Predicted estimates for times 1,...,N
%   Pp          [n x n x N] Filter error convariance
%

%% Parameters
N = size(Y,2);

n = length(x_0);
m = size(Y,1);

%% Data allocation
xf = zeros(n,N);
Pf = zeros(n,n,N);

x_prior = x_0;
P_prior = P_0;

%[xf(:,1), Pf(:,:,1)] = nonLinKFupdate(x_prior,P_prior, Y(:,1), h, R, type);

xf(:,1) = x_0;
pf(:,:,1) = P_prior;

for k=2:N    
    
    [xp(:,k),Pp(:,:,k)] = nonLinKFprediction(xf(:,k-1), Pf(:,:,k-1), f, Q, type);
    [xf(:,k), Pf(:,:,k)] = nonLinKFupdate(xp(:,k),Pp(:,:,k), Y(:,k), h, R, type);

end


end