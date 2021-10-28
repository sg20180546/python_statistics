%==========================================================================
%
% Question_1.m
% Main file to estimate VAR model for Korea with fiscal data
%==========================================================================

clc;
format short g;
close all;
clear all;

rand('state',26);
randn('state',26);

%%GDP, Goverment
X00=xlsread('korea_data_fiscal_var.xls');

logGDP=X00(:,2);
logGOV=X00(:,1);




T=size(logGDP,1);
%% CORRELATION BETWEEN GDP AND GOV
GDP_GOV_CORRELATION=corrcoef(logGDP,logGOV);
%% GDP
[hp_trend_gdp,hp_cyclical_gdp]=hpfilter(logGDP,1600);
logGDP_hpfiltered=hp_cyclical_gdp*100;

%% GOV
[hp_trend_GOV,hp_cyclical_GOV]=hpfilter(logGOV,1600);
logGOV_hpfiltered=hp_cyclical_GOV*100;



%% plot
dt=(2000 : 0.25 :2019+0.5);




%% GDP Plot
figure(1);
subplot(2,1,1);
series1=logGDP;
series2=hp_trend_gdp;
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
series1=logGDP_hpfiltered;
maxvar=1.05*max(series1);
minvar=min(series1)-.01*abs(min(series1));
plot(dt,series1);
hold on
plot(dt,zeros(T,1));
hold off
axis tight
ylim([minvar maxvar]);
grid on


%% GOV PLOT

figure(2);
subplot(2,1,1);
series1=logGOV;
series2=hp_trend_GOV;
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
series1=logGOV_hpfiltered;
maxvar=1.05*max(series1);
minvar=min(series1)-.01*abs(min(series1));
plot(dt,series1);
hold on
plot(dt,zeros(T,1));
hold off
axis tight
ylim([minvar maxvar]);
grid on
