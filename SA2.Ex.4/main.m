clear all;
close all;
clc;

mu_x = 0;
sigma2_x = 1;
y = 1;
sigma2_r = 2;


[mu, sigma2] = posteriorGaussian(mu_x, sigma2_x, y, sigma2_r);

%%
figure();
xlimit = 2*sqrt(sigma2_x);
xs = linspace(mu_x-xlimit,mu_x+xlimit,100);
ylimit = 2*sqrt(sigma2_r);
ys = linspace(y-ylimit,y+ylimit,100);


subplot(3,1,1);
plot(xs,normpdf(xs, mu_x, sigma2_x));
title('Prior');
xlims = get(gca, 'XLim');


subplot(3,1,2);
plot(ys,normpdf(ys, y, sigma2_r));
title('Likelihood');
xlim(xlims);

subplot(3,1,3);
plot(xs,normpdf(xs, mu, sigma2));
title('Posterior');
xlim(xlims);

%%
N = 1000;
x_s = mvnrnd(mu_x,sigma2_x,N)';

%y_s = mvnrnd(mu_x,Sigma_x,N)';