clear all;
close all;
clc;

h = @(x) h(x);

mu_x = [7,3]';
Sigma_x = [0.2 0
           0   8
            ];

N = 1000;
[mu_y,Sigma_y,xs] = approxGaussianTransform(mu_x, Sigma_x, h, N);
mu_y
Sigma_y
%%
figure();
histogram(xs(1,:),100);

figure();
histogram(xs(2,:),100);