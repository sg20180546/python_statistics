clc;
format short g;
close all;
clear all;

tic

rand('state',26);
randn('state',26);

ntotal=200;
nburnin=100;
nsimper=ntotal-nburnin;

X_0=0;

rho=0.1;

shocks=randn(ntotal,1);
X=zeros(ntotal,1);

for i=1:ntotal
    if i==1
        X(i,1)=X_0+shocks(i,1);
    else
        X(i,1)=rho*X(i-1,1)+shocks(i,1);
    end
end

X_rho_1=X(nburnin+1:end,:);

titles={'AR(1) Process'};

figure(1);

dt = (1:1:nsimper)';
series1=X_rho_1(:,1);
subplot(1,1,1);
plot(dt,series1);
hold on
plot(dt,zeros(nsimper,1))
hold off