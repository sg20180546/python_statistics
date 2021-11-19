%==========================================================================
%
% Question_2.m
% Main file to estimate VAR model for Korea with fiscal data
%==========================================================================



clc;
format short g;
close all;
clear all;

rand('state',26);
randn('state',26);

%% data
X00=xlsread('korea_data_fiscal_var.xls');
nlags=3;
nsteps=21;


logGOV=X00(:,1);
logY=X00(:,2);
logCPI=X00(:,3);
interestRate=X00(:,4);


% y_growth = (log(X00(2:end,1))-log(X00(1:end-1,1)))*100;     % calculate GDP growth
% inflation = (log(X00(2:end,2))-log(X00(1:end-1,2)))*100;    % calculate inflation rate


% y_growth = (logY(2:end,:)-logY(1:end-1,:) )*100;     % calculate GDP growth
% GOV_Growth (logGOV(2:end,:) -logGOV(1:end-1,:))*100;
% inflation (logCPI(2:end,:) - logCPI(1:end-1,:))*100;


% inflation = (logCPI(2:end,2)-logCPI(1:end-1,2))*100;    % calculate inflation rate



EXO_Y=X00(:,7);
EXO_i=X00(:,8);
EXO_Oil=X00(:,9);
ExchangeRate=X00(:,10);

EXO=[EXO_Y EXO_i EXO_Oil ExchangeRate];


X=[logGOV logY logCPI interestRate];

YY=X(nlags+1:end,:);

[TT,nvar]=size(YY);

XX00=zeros(TT,nvar*nlags);

for i=1:nlags %nlags =3
    XX00(:,nvar*(i-1)+1:nvar*i)=X(nlags-i+1:end-i,:);
end

X_determin=[ones(TT,1) EXO(nlags+1:end,:) ];
n_determin=size(X_determin,2);

XX=[X_determin, XX00];

%% beta
beta= inv(XX'*XX)*XX'*YY;

u=YY-XX*beta;
sigma=u'*u/TT;
L=chol(sigma)';

PI=beta(n_determin+1:end,:)';

if nlags>1
    nsub=size(PI,2)-nvar
    prePi=[eye(nsub) zeros(nsub,nvar)];
    PI=[PI; prePi];
end

shock=4;

irf=zeros(nsteps,nvar);
temp=eye(nvar*nlags);

for i=1:nsteps
    temp2=temp(1:nvar,1:nvar)*L;
    irf(i,:)=temp2(:,shock);
    temp=temp*PI;
end

dt=(0:1:nsteps-1)';


figure(1)

for ii=1:4
    subplot(2,2,ii)
    series=irf(:,ii);
    maxvar=1.01*max(max(series),max(series));
    minvar=min(series)-0.1*min(abs(series));
    minvar=min(minvar,minvar);
    plot(dt,series)
    hold on
    plot(dt,zeros(nsteps,1));
    hold off
    axis tight;
    ylim([minvar maxvar])
    grid on
end




