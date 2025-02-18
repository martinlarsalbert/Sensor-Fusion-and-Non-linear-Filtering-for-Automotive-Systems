clear all;
close all;
clc;

mu_x = 180;
sigma2_x = 10^2;
y = 200;
sigma2_r = 40^2;


[mu, sigma2] = posteriorGaussian(mu_x, sigma2_x, y, sigma2_r)

sqrt(sigma2)