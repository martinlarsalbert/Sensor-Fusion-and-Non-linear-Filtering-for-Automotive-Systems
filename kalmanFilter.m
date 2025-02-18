function [X, P] = kalmanFilter(Y, x_0, P_0, A, Q, H, R)
%KALMANFILTER Filters measurements sequence Y using a Kalman filter. 
%
%Input:
%   Y           [m x N] Measurement sequence
%   x_0         [n x 1] Prior mean
%   P_0         [n x n] Prior covariance
%   A           [n x n] State transition matrix
%   Q           [n x n] Process noise covariance
%   H           [m x n] Measurement model matrix
%   R           [m x m] Measurement noise covariance
%
%Output:
%   X           [n x N] Estimated state vector sequence
%   P           [n x n x N] Filter error convariance
%

%% Parameters
N = size(Y,2);

n = length(x_0);
m = size(Y,1);

%% Data allocation
X = zeros(n,N);
P = zeros(n,n,N);
    

%% Solution (wrong)

[X(:,1), P(:,:,1)] = linearUpdate(x_0,P_0, Y(:,1), H, R);

for k=2:N    

    [x_prd,P_prd] = linearPrediction(X(:,k-1), P(:,:,k-1), A, Q);
    [X(:,k), P(:,:,k)] = linearUpdate(x_prd,P_prd, Y(:,k), H, R);

end

%% Solution (correct)

[x_prd,P_prd] = linearPrediction(x_0, P_0, A, Q);

for k=1:N    
    
    [X(:,k), P(:,:,k)] = linearUpdate(x_prd,P_prd, Y(:,k), H, R);

    [x_prd,P_prd] = linearPrediction(X(:,k), P(:,:,k), A, Q);
    

end

