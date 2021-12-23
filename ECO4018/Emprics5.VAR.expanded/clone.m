clc
format short g;
close all;
clear all;


tic

rand('state',26);
randn('state',26);

nlags=3;
nsteps=21;

X00=xlsread('20180546_data.xlsx');


X00_exo_temp=X00(2:end,1:3);
X00_endo_temp=X00(2:end,4:end);

y_us=log(X00_exo_temp(:,1));
i_us=X00_exo_temp(:,2);
oil_price=log(X00_exo_temp(:,3));

g_kr=log(X00_endo_temp(:,1));
g_kr=X00_endo_temp(:,1);
y_kr=log(X00_endo_temp(:,2));
p_kr=log(X00_endo_temp(:,3));
i_kr=X00_endo_temp(:,4);
c_kr=X00_endo_temp(:,5);
ex_kr=log(X00_endo_temp(:,6));
invest_kr=log(X00_endo_temp(:,7));

%% Construct var data

% EXO=[y_us i_us oil_price];
EXO=[oil_price];
% EXO=[];
X=[g_kr y_kr p_kr i_kr c_kr ex_kr invest_kr];

YY=X(nlags+1:end,:);

[TT,nvar]=size(YY);

XX00=zeros(TT,nvar*nlags);


for i=1:nlags %nlags =3
    XX00(:,nvar*(i-1)+1:nvar*i)=X(nlags-i+1:end-i,:);
end

X_det=[ones(TT,1) EXO(nlags+1:end,:)];
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

shock=1;

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

 titles = {  'Impulse response of Goverment Spending to G shock : Korea';
             'Impulse response of GDP to a G shock';
         'Impulse response of CPI to a G shock';
         'Impulse response of nominal interest rate to a G shock';
        'Impulse response of Consumption to a G shock';
           'Impulse response of nominal exchange rate to a G shock';
        'Impulse response of Investment to G shock'};
      

%  titles = {  'Impulse response of Goverment Spending to MP shock';
%            'Impulse response of Y to MP shock : Korea';
%             'Impulse response of CPI to a MP shock';
%         'Impulse response of nominal interest rate to a MP shock';
%            'Impulse response of Consumption to a MP shock';
%         'Impulse response of Exchange Rate to a MP shock';
%         'Impulse response of Investment to MP shock';};
      
for ii=1:7
    subplot(4,2,ii)
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
    title(char(titles(ii)), 'fontsize', 10);
    grid on
end
toc

