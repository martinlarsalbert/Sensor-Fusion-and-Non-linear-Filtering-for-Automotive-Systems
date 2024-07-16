function [SP,W] = sigmaPoints(x, P, type)
% SIGMAPOINTS computes sigma points, either using unscented transform or
% using cubature.
%
%Input:
%   x           [n x 1] Prior mean
%   P           [n x n] Prior covariance
%
%Output:
%   SP          [n x 2n+1] UKF, [n x 2n] CKF. Matrix with sigma points
%   W           [1 x 2n+1] UKF, [1 x 2n] UKF. Vector with sigma point weights 
%

n = size(P,1);
P_sqrt = sqrtm(P);

    switch type        
        case 'UKF'
    
            W_0 = 1 - n/3; % x is Gaussian
            N = 2*n+1;
            
            %Calculate sigma points:
            W = zeros(1,N);
            SP = zeros(n,N);
            
            S = sqrt(n/(1-W_0));
            W_n = (1-W_0)/(2*n);
            W(1) = W_0;
            SP(:,1) = x;
            for i=1:n
                j = i + 1;
                W(j) = W_n;
                W(j+n) = W_n;
                
                SP(:,j) = x + S*P_sqrt(:,i);
                SP(:,j+n) = x -S*P_sqrt(:,i);

            end;
                
        case 'CKF'

            N = 2*n;
            
            %Calculate sigma points:
            W = zeros(1,N);
            SP = zeros(n,N);
            
            W_n = 1/(2*n);
            S = sqrt(n);
            for i=1:n
                W(i) = W_n;
                W(i+n) = W_n;
                
                SP(:,i) = x + S*P_sqrt(:,i);
                SP(:,i+n) = x -S*P_sqrt(:,i);

            end;
            
            
            
        otherwise
            error('Incorrect type of sigma point')
    end

end