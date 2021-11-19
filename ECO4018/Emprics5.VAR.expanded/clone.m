clc
format short g;
close all;
clear all;


tic

rand('state',26);
randn('state',26);

nlags=3;
nsteps=21;

X00=xlsread('var_data_expanded_korea.xls');


X00_exo_temp=X00(2:end,1:3);
X00_endo_temp=X00(2:end,4:end);

y_us=log(X00_exo_temp(:,1));
i_us=X00_exo_temp(:,2);
oil_price=log(X00_exo_temp(:,3));

y_kr=log(X00_endo_temp(:,1));
p_kr=log(X00_endo_temp(:,2));
i_kr=X00_endo_temp(:,3);
ex_kr=log(X00_endo_temp(:,4));

%% Construct var data

EX0=[y_us i_us oil_price];

X=[y_kr p_kr i_kr ex_kr];

YY=X(nlags+1:end,:);

[TT,nvar]=size(YY);

XX00=zeros(TT,nvar*nlags);


for i=1:nlags %nlags =3
    XX00(:,nvar*(i-1)+1:nvar*i)=X(nlags-i+1:end-i,:);
end

X_det=[ones(TT,1) EX0(nlags+1:end,:)];
n_det=size(X_det,2);

XX=[X_det XX00];

%% VAR ESTIMATIOn
beta=inv(XX'*XX)*XX'*YY;

u=YY-XX*beta;
sigma=u'*u/TT

L=chol(sigma)';

PI=beta(n_det+1:end,:)';

if nlags>1
    nsub=size(PI,2)-nvar
    prePi=[eye(nsub) zeros(nsub,nvar)];
    PI=[PI; prePi];
end

shock=3;

irf=zeros(nsteps,nvar);
temp=eye(nvar*nlags);

for i=1:nsteps
    temp2=temp(1:nvar,1:nvar)*L;
    irf(i,:)=temp2(:,shock);
    temp=temp*PI;
end

dt=(0:1:nsteps-1)';

%% PLOt

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
toc

