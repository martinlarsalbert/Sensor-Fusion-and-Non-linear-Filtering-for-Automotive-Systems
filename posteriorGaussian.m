function [mu, sigma2] = posteriorGaussian(mu_x, sigma2_x, y, sigma2_r)
%posteriorGaussian performs a single scalar measurement update with a
%measurement model which is simply "y = x + noise".
%
%Input
%   MU_P            The mean of the (Gaussian) prior density.
%   SIGMA2_P        The variance of the (Gaussian) prior density.
%   SIGMA2_R        The variance of the measurement noise.
%   Y               The given measurement.
%
%Output
%   MU              The mean of the (Gaussian) posterior distribution
%   SIGMA2          The variance of the (Gaussian) posterior distribution

%Your code here
    
    % p(y|x) = N(y; mu_x, sigma_r)
    
    sigma2_y = sigma2_r;   
    
    %"completing the squares" gives:
    mu = (mu_x/sigma2_x + y/sigma2_y) / (1/sigma2_x + 1/sigma2_y);
    sigma2 = 1 / (1/sigma2_x + 1/sigma2_y);

end