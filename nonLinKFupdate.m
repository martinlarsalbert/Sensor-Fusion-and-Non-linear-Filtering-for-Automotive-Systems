function [x, P] = nonLinKFupdate(x, P, y, h, R, type)
%NONLINKFUPDATE calculates mean and covariance of predicted state
%   density using a non-linear Gaussian model.
%
%Input:
%   x           [n x 1] Predicted mean
%   P           [n x n] Predicted covariance
%   y           [m x 1] measurement vector
%   h           Measurement model function handle
%               [hx,Hx]=h(x) 
%               Takes as input x (state), 
%               Returns hx and Hx, measurement model and Jacobian evaluated at x
%               Function must include all model parameters for the particular model, 
%               such as sensor position for some models.
%   R           [m x m] Measurement noise covariance
%   type        String that specifies the type of non-linear filter
%
%Output:
%   x           [n x 1] updated state mean
%   P           [n x n] updated state covariance
%

    switch type
        case 'EKF'
            
            [hx, Hx] = h(x);
            S_k = Hx*P*Hx' + R;
            K_k = P*Hx'*inv(S_k);
            x = x + K_k*(y-hx);
            P = P - K_k*S_k*K_k';
            
        case {'UKF','CKF'}
    
            [SP,W] = sigmaPoints(x, P, type);
            [n,N] = size(SP);
            m = length(y);
            g = zeros(m,N);
            
            % y_k:
            y_pred=zeros(m,1);
            for i=1:N
                [g(:,i),Hx]=h(SP(:,i));
                y_pred = y_pred + W(i)*g(:,i);
            end
            
            % P_xy:
            P_xy = zeros(n,m);
            for i=1:N
                P_xy = P_xy + W(i)*(SP(:,i) - x)*(g(:,i)-y_pred)';
            end;
            

            % S_k:
            S_k = zeros(m,m);
            for i=1:N
                S_k = S_k + W(i)*(g(:,i)-y)*(g(:,i)-y_pred)';
            end;
            S_k = S_k + R;

            x = x + P_xy*inv(S_k)*(y-y_pred);
            P = P - P_xy*inv(S_k)*P_xy';
                       
        otherwise
            error('Incorrect type of non-linear Kalman filter')
    end

end