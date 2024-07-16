function [x, P] = nonLinKFprediction(x, P, f, Q, type)
%NONLINKFPREDICTION calculates mean and covariance of predicted state
%   density using a non-linear Gaussian model.
%
%Input:
%   x           [n x 1] Prior mean
%   P           [n x n] Prior covariance
%   f           Motion model function handle
%               [fx,Fx]=f(x) 
%               Takes as input x (state), 
%               Returns fx and Fx, motion model and Jacobian evaluated at x
%               All other model parameters, such as sample time T,
%               must be included in the function
%   Q           [n x n] Process noise covariance
%   type        String that specifies the type of non-linear filter
%
%Output:
%   x           [n x 1] predicted state mean
%   P           [n x n] predicted state covariance
%
    
    switch type
        case 'EKF'
           
            [fx,Fx]=f(x);
            x = fx;
            P = Fx*P*Fx' + Q;
            
        case 'UKF'
    
            [SP,W] = sigmaPoints(x, P, type);
            [n,N] = size(SP);
            g = zeros(n,N);
            x=zeros(n,1);
            P = zeros(n,n);
            for i=1:N
                [g(:,i),Fx]=f(SP(:,i));
                x = x + W(i)*g(:,i);
            end
            for i=1:N
                P = P + W(i)*(g(:,i)-x)*(g(:,i)-x)';
            end
            P = P + Q;

                
        case 'CKF'
            
            [SP,W] = sigmaPoints(x, P, type);
            [n,N] = size(SP);
            g = zeros(n,N);
            x=zeros(n,1);
            P = zeros(n,n);
            for i=1:N
                [g(:,i),Fx]=f(SP(:,i));
                x = x + W(i)*g(:,i);
            end
            for i=1:N
                P = P + W(i)*(g(:,i)-x)*(g(:,i)-x)';
            end
            P = P + Q;

        otherwise
            error('Incorrect type of non-linear Kalman filter')
    end

end