clc;
format short g;
close all;
clear all;

tic;

rand('state',26);
randn('state',26);

ntotal=200;
nburnin=100;
nsimper=ntotal-nburnin;

X_0=0;
shocks=randn(ntotal,1);

rho=0.5;

X=zeros(ntotal,1);

for i=1:ntotal
    if i==1
        X(i,1)=rho*X_0+shocks(i,1);
    else
        X(i,1)=rho*X(i-1)+shocks(i,1);
    end
end

X_rho_5=X(nburnin+1:end,:);

%%OLS regressin ar(2)
yvar=X_rho_5(3:end,1);
T=size(yvar,1);

xvar=[ones(T,1) X_rho_5(2:end-1) X_rho_5(1:end-2)];

m=size(xvar,2);

betas=inv(xvar'*xvar)*xvar'*yvar;

residual=yvar-xvar*betas;

sigma_sq=(residual'*residual)/T;

adj_R_Sq=1- ( (residual'*residual)/(T-m)) / ( (yvar'*yvar)/(T-1)) ;

dt=(1:1:T)';

figure(1);
subplot(2,1,1);
xval=xvar(:,2);
yval=yvar;
maxxval=max(xval)+0.1;
minxval=min(xval)-0.1;
maxyval=max(yval)+0.1;
minyval=min(yval)-0.1;
xdom=(minxval:0.01:maxxval)';

predicted_y=betas(1,1)*ones( size(xdom,1),1)+betas(2,1)*xdom;

plot(xdom,predicted_y);
hold on
scatter(xval,yval);
hold off;

subplot(2,1,2);
plot(dt,residual);
hold on;
plot(dt,zeros(T,1));
hold off;

