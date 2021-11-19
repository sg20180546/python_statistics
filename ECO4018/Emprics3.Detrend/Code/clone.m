clc;
format short g;
clear all;
close all;

tic;
rand('state',26);
randn('state',26);

X00=xlsread('data_empirics_3.xls');

y=X00(:,3);
recession_index=X00(:,4);


log_y=log(y);
T=size(log_y,1);

lin_trend=(1:1:T)';
%% linear
yvar=log_y;
xvar=[ones(T,1) lin_trend];

betas=inv(xvar'*xvar)*xvar'*yvar;

residual=yvar-xvar*betas;

log_y_lin_trend=xvar*betas;
log_y_lin_detrended=residual*100;

%% quadratic

yvar=log_y;
xvar=[ones(T,1) lin_trend lin_trend.^2];

betas=inv(xvar'*xvar)*xvar'*yvar;

residual=yvar-xvar*betas;

log_y_quad_trend=xvar*betas;
log_y_quad_detrend=residual*100;

%% hp filter

[hp_trend,hp_cyclical]=hpfilter(log_y,1600);
log_y_hpfiltered=hp_cyclical*100;

%% plot
dt=(1999+0.125+0.25*2:0.25:2021+0.125+0.25);

through=zeros(T,1);
through(8)=1;
through(221)=1;
through(39)=1;
through(54)=1;
through(63)=1;
through(84)=1;

peak=zeros(T,1);
peak(5)=1;
peak(14)=1;
peak(35)=1;
peak(47)=1;
peak(60)=1;

peak(82)=1;

[it,jt]=find(through);
[ip,jp]=find(peak);
%% linear plot
%trend lin
figure(1);
subplot(2,1,1);
series1=log_y;
series2=log_y_lin_trend;
maxvar=1.01*max(max(series1),max(series2) );

minvar1=min(series1)-.01*abs(min(series1));
minvar2=min(series2)-.01*abs(min(series2));
minvar=min(minvar1,minvar2);

plot(dt,series1);
hold on
plot(dt,series2);
plot(dt,zeros(T,1));
hold off
axis tight
ylim([minvar maxvar]);
grid on;
hh = legend('Actual data','Time trend (linear)','Location','NorthWest','Orientation','Horizontal');

%---detrened lin
subplot(2,1,2);
series1=log_y_lin_detrended;
maxvar=1.05*max(series1);
minvar=min(series1)-.05*abs(min(series1));
plot(dt,series1);
hold on
plot(dt,zeros(T,1));
hold off
axis tight
ylim([minvar maxvar]);

%% quad plot
figure(2);
subplot(2,1,1);
series1=log_y;
series2=log_y_quad_trend;
maxvar=1.01*max(max(series1), max(series2));
minvar1= min(series1) -.01*abs(min(series1));
minvar2= min(series2) -.01*abs(min(series2));
minvar=min(minvar1,minvar2);
plot(dt,series1);
hold on
plot(dt,series2);
plot(dt,zeros(T,1));
hold off;
axis tight;
ylim([minvar maxvar]);

subplot(2,1,2);
series1=log_y_quad_detrend;
maxvar=1.05*max(series1);
minvar=min(series1)-.05*abs(min(series1));
plot(dt,series1);
hold on
plot(dt,zeros(T,1));
hold off
axis tight;
ylim([minvar maxvar]);



%% hp filter plot
figure(3);
subplot(2,1,1);
series1=log_y;
series2=hp_trend;
maxvar=1.05*max(max(series1),max(series2));
minvar1=min(series1)-.01*abs(min(series1));
minvar2=min(series2)-.01*abs(min(series2));
minvar=min(minvar1,minvar2);
plot(dt,series1);
hold on
plot(dt,series2);
plot(dt,zeros(T,1));
hold off;
axis tight
ylim( [minvar maxvar] );
grid on

subplot(2,1,2);
series1=log_y_hpfiltered;
maxvar=1.05*max(series1);
minvar=min(series1)-.01*abs(min(series1));
plot(dt,series1);
hold on
plot(dt,zeros(T,1));
hold off
axis tight
ylim([minvar maxvar]);
grid on
