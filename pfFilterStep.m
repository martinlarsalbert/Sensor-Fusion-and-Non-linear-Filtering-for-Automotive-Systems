function [X_k, W_k] = pfFilterStep(X_kmin1, W_kmin1, yk, proc_f, proc_Q, meas_h, meas_R)
%PFFILTERSTEP Compute one filter step of a SIS/SIR particle filter.
%
% Input:
%   X_kmin1     [n x N] Particles for state x in time k-1
%   W_kmin1     [1 x N] Weights for state x in time k-1
%   y_k         [m x 1] Measurement vector for time k
%   proc_f      Handle for process function f(x_k-1)
%   proc_Q      [n x n] process noise covariance
%   meas_h      Handle for measurement model function h(x_k)
%   meas_R      [m x m] measurement noise covariance
%
% Output:
%   X_k         [n x N] Particles for state x in time k
%   W_k         [1 x N] Weights for state x in time k

% Your code here!

% Prediction step
N = length(W_kmin1);  % Number of particles
X_k = proc_f(X_kmin1);
X_k = X_k + mvnrnd([0, 0], proc_Q, N)'; % Add process noise


% Update step
expectedMeasurements  = meas_h(X_k);
measurementErrors = expectedMeasurements - yk; % Calculate errors


% Calculate the likelihoods considering measurement uncertainty
likelihoods = exp(-0.5 * (measurementErrors.^2) / meas_R);


% Update weights considering the proposal density
weights = W_kmin1 .* likelihoods;
W_k = weights / sum(weights); % Normalize weights



end