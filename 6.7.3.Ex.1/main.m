clear all;
close all;
clc;

mu = 0.5;
sigma = 0.9/3;
x = linspace(-1,2,100);
y = pdf('Normal',x,mu,sigma);

figure();
hold on;
plot(x,y);

k=1/3;
m=2;
hs = m + x*k;
plot(x,hs);

xs = normal(mu,sigma, 100000);
hss = m + xs*k;

figure();
histogram(hss,100,'Normalization','probability');