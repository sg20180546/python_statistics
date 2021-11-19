clc; 
format short g;
clear all;
close all;

tic
rand('state',26);
randn('state',26);

X00=xlsread('var_data.xls');


country_flag=1; %1 us 2 korea

nlags=3;
nsteps=21;

if country_flag==1
    X00=X00(:,1:3);
else
    X00=X00(:,4:end);
end

y_growth=(log(X00(2:end,1)) -log(X00(1:end-1,1)))*100;
inflation=(log(X00(2:end,2)) -log(X00(1:end-1,2)) )*100;
interest_rate=X00(2:end,3);

X=[y_growth inflation interest_rate];

YY=X(nlags+1:end,:);

[TT,nvar]=size(YY);

XX00=zeros(TT,nvar*nlags);

for i=1:nlags
    XX00(:, nvar*(i-1)+1:nvar*i) = X(nlags-i+1:end-i,:);
end

XX=[ones(TT,1) XX00];

beta=inv(XX'*XX)*XX'*YY;
u=YY-XX*beta;

sigma=u'*u/TT;

%% hard
L=chol(sigma)';

PI=beta(2:end,:)';

if nlags>1
    nsub=size(PI,2)-nvar; %9-3;
    prePi=[eye(nsub) zeros(nsub,nvar)];
    PI=[PI; prePi];
end

%% impulse response
shock=3;
irf=zeros(nsteps,nvar);
temp=eye(nvar*nlags);

for i=1:nsteps
    temp2=temp(1:nvar,1:nvar)*L;
    irf(i,:)=temp2(:,shock)';
    check=temp2(:,shock)';
    temp=temp*PI;
    
end

figure(1)
dt=(0:1:nsteps-1)';

for ii=1:3
    subplot(3,1,ii)
    series1=irf(:,ii);
    maxvar=1.01*max(series1);
    minvar=min(series1) - .01*abs(min(series1));
    plot(dt,series1);
    hold on
    plot(dt,zeros(nsteps,1));
    hold off;
    axis tight;
    ylim([minvar maxvar]);
    grid on
end
    
