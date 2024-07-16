function [hx, Hx] = dualBearingMeasurement(x, s1, s2)
%DUOBEARINGMEASUREMENT calculates the bearings from two sensors, located in 
%s1 and s2, to the position given by the state vector x. Also returns the
%Jacobian of the model at x.
%
%Input:
%   x           [n x 1] State vector, the two first element are 2D position
%   s1          [2 x 1] Sensor position (2D) for sensor 1
%   s2          [2 x 1] Sensor position (2D) for sensor 2
%
%Output:
%   hx          [2 x 1] measurement vector
%   Hx          [2 x n] measurement model Jacobian
%
% NOTE: the measurement model assumes that in the state vector x, the first
% two states are X-position and Y-position.

% Your code here
    
    n = length(x);
    %hx = zeros(n,1);
    %hx(1) = atan2(x(2)-s1(2), x(1)-s1(1));
    %hx(2) = atan2(x(2)-s2(2), x(1)-s2(1));
    hx = [
        atan2(x(2)-s1(2), x(1)-s1(1));
        atan2(x(2)-s2(2), x(1)-s2(1));
    ];
    
    x_k = x(1)-s1(1);
    y_k = x(2)-s1(2);
    ddx1 = -y_k/(x_k^2+y_k^2);
    ddy1 = x_k/(x_k^2+y_k^2);

    x_k = x(1)-s2(1);
    y_k = x(2)-s2(2);
    ddx2 = -y_k/(x_k^2+y_k^2);
    ddy2 = x_k/(x_k^2+y_k^2);

    
    Hx = zeros(2,n);

    %Hx = [
    %    ddx1, ddy1,0, 0;
    %    ddx2, ddy2,0, 0;
    %];

    Hx(1,1) = ddx1;
    Hx(1,2) = ddy1;
    Hx(2,1) = ddx2;
    Hx(2,2) = ddy2;

end