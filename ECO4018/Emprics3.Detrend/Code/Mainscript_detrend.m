%==========================================================================
%
% Mainscript_detrend.m
% Main file to detrend time series
%
%                                        Joonyoung Hur (joonyhur@gmail.com)
%                                    School of Economics, Sogang Univeristy
%==========================================================================

clc;
format short g;
close all;
clear all;

tic

rand('state',26);
randn('state',26);

%% Load data
X00 = xlsread('data_empirics_3.xls');           % load data from the excel file

y = X00(:,3);                                   % real GDP per capita
recession_index = X00(:,4);                     % recession index (OECD)

log_y = log(y);                                 % log(real GDP per capita)

T = size(log_y,1);                              % number of observation

%% Detrend data 1: linear time trend
lin_trend = (1:1:T)';                           % linear time trend

yvar = log_y;                                   % regressand
xvar = [ones(T,1) lin_trend];                   % regressor

betas = inv(xvar'*xvar)*xvar'*yvar;             % OLS estimates for the coefficients

residual = yvar - xvar*betas;                   % OLS residuals

log_y_lin_trend = xvar*betas;                   % linear trend of log(real GDP per capita)
log_y_lin_detrended = residual*100;             % linear detrended log(real GDP per capita), 100 is multiplied to convert to percentages

%% Detrend data 2: quadratic time trend
yvar = log_y;                                   % regressand
xvar = [ones(T,1) lin_trend lin_trend.^2];      % regressor, quadratic time trend term is added

betas = inv(xvar'*xvar)*xvar'*yvar;             % OLS estimates for the coefficients

residual = yvar - xvar*betas;                   % OLS residuals

log_y_quad_trend = xvar*betas;                  % quadratic trend of log(real GDP per capita)
log_y_quad_detrended = residual*100;            % quadratic detrended log(real GDP per capita), 100 is multiplied to convert to percentages

%% Detrend data 3: Hodrick-Prescott filter
[hp_trend,hp_cyclical] = hpfilter(log_y,1600);  % remove trend using Hodrick-Prescott filter

log_y_hpfiltered = hp_cyclical*100;             % HP-filtered log(real GDP per capita), 100 is multiplied to convert to percentages

%% Plot
color0 = rgb('Black');
color1 = rgb('MediumBlue');
color2 = rgb('Crimson');
color3 = rgb('RoyalBlue');
color4 = rgb('ForestGreen');
color5 = rgb('Navy');
color6 = rgb('OrangeRed');
color7 = rgb('Purple');
color8 = rgb('MediumVioletRed');
color9 = rgb('Cyan');
color10 = rgb('Magenta');
color11 = rgb('Lime');
color12 = rgb('LightCyan');
color13 = rgb('HotPink');
color14 = rgb('GreenYellow');
color15 = rgb('Salmon');
color16 = rgb('Gray');
color17 = rgb('LightGray');
color18 = rgb('Gold');
color19 = rgb('DarkGray');
color20 = rgb('DarkCyan');
color21 = rgb('Lavender');
color22 = rgb('LightBlue');
color23 = rgb('LightCoral');

dt = (1999+0.125+0.25*2:0.25:2021+0.125+0.25)';

%===Date recession
through = zeros(T,1);
through(8) = 1;
through(22) = 1;
through(39) = 1;
through(54) = 1;
through(63) = 1;
through(84) = 1;

peak = zeros(T,1);
peak(5) = 1;
peak(14) = 1;
peak(35) = 1;
peak(47) = 1;
peak(60) = 1;
peak(82) = 1;

[it,jt]=find(through);
[ip,jp]=find(peak);

%===linear
titles = {'Actual data and linear time trend';
          'Linear detrended data'};

figure(1)
subplot(2,1,1)
series1 = log_y;                    % actual data
series2 = log_y_lin_trend;          % linear time trend
maxvar = 1.01*max(max(series1),max(series2));
minvar1 = min(series1)-.01*abs(min(series1));
minvar2 = min(series2)-.01*abs(min(series2));
minvar = min(minvar1,minvar2);
plot(dt,series1,'-', 'Color', color5, 'MarkerSize',3, 'linewidth',2);
hold on
plot(dt,series2,'-', 'Color', color2, 'MarkerSize',3, 'linewidth',1);
plot(dt,zeros(T,1),'-', 'Color', color0, 'MarkerSize',3, 'linewidth',1);
hold off
title(char(titles(1)), 'fontsize', 10);
axis tight
ylim([minvar maxvar])
grid on
hh = legend('Actual data','Time trend (linear)','Location','NorthWest','Orientation','Horizontal');
set(hh,'box','off');

subplot(2,1,2)
series1 = log_y_lin_detrended;      % linear detrended data
maxvar = 1.05*max(max(series1),max(series1));
minvar1 = min(series1)-.05*abs(min(series1));
minvar = min(minvar1,minvar1);
plot(dt,series1,'-', 'Color', color8, 'MarkerSize',3, 'linewidth',3);
hold on
for ll=1:length(jp)
    area([dt(ip(ll)) dt(it(ll))],[0.99 0.99]*maxvar,minvar,'FaceColor',color17,'EdgeColor',color17)
end
plot(dt,zeros(T,1),'-', 'Color', color0, 'MarkerSize',3, 'linewidth',1);
plot(dt,series1,'-', 'Color', color8, 'MarkerSize',3, 'linewidth',3);
hold off
title(char(titles(2)), 'fontsize', 10);
axis tight
ylim([minvar maxvar])
hh = legend('Detrended data (linear)','Recession dates','Location','NorthEast','Orientation','Horizontal');
set(hh,'box','off');

figure(1)
set(gcf, 'Units', 'inches');
set(gcf, 'Position', [0 0 9.9 5.3]);
set(gcf, 'renderer', 'painters');
set(gcf, 'PaperPositionMode', 'auto');
% print(gcf, '-depsc2', '-painters', ['lin_trend.eps'])
% close

%===quadratic
titles = {'Actual data and quadratic time trend';
          'Quadratic detrended data'};

figure(2)
subplot(2,1,1)
series1 = log_y;                    % actual data
series2 = log_y_quad_trend;         % quadratic time trend
maxvar = 1.01*max(max(series1),max(series2));
minvar1 = min(series1)-.01*abs(min(series1));
minvar2 = min(series2)-.01*abs(min(series2));
minvar = min(minvar1,minvar2);
plot(dt,series1,'-', 'Color', color5, 'MarkerSize',3, 'linewidth',2);
hold on
plot(dt,series2,'-', 'Color', color2, 'MarkerSize',3, 'linewidth',1);
plot(dt,zeros(T,1),'-', 'Color', color0, 'MarkerSize',3, 'linewidth',1);
hold off
title(char(titles(1)), 'fontsize', 10);
axis tight
ylim([minvar maxvar])
grid on
hh = legend('Actual data','Time trend (quadratic)','Location','NorthWest','Orientation','Horizontal');
set(hh,'box','off');

subplot(2,1,2)
series1 = log_y_quad_detrended;      % quadratic detrended data
maxvar = 1.05*max(max(series1),max(series1));
minvar1 = min(series1)-.05*abs(min(series1));
minvar = min(minvar1,minvar1);
plot(dt,series1,'-', 'Color', color8, 'MarkerSize',3, 'linewidth',3);
hold on
for ll=1:length(jp)
    area([dt(ip(ll)) dt(it(ll))],[0.99 0.99]*maxvar,minvar,'FaceColor',color17,'EdgeColor',color17)
end
plot(dt,zeros(T,1),'-', 'Color', color0, 'MarkerSize',3, 'linewidth',1);
plot(dt,series1,'-', 'Color', color8, 'MarkerSize',3, 'linewidth',3);
hold off
title(char(titles(2)), 'fontsize', 10);
axis tight
ylim([minvar maxvar])
hh = legend('Detrended data (quadratic)','Recession dates','Location','NorthEast','Orientation','Horizontal');
set(hh,'box','off');

figure(2)
set(gcf, 'Units', 'inches');
set(gcf, 'Position', [0 0 9.9 5.3]);
set(gcf, 'renderer', 'painters');
set(gcf, 'PaperPositionMode', 'auto');
% print(gcf, '-depsc2', '-painters', ['quad_trend.eps'])
% close

%===HP filtered
titles = {'Actual data and HP trend';
          'HP filtered data'};

figure(3)
subplot(2,1,1)
series1 = log_y;                    % actual data
series2 = hp_trend;                 % HP trend
maxvar = 1.01*max(max(series1),max(series2));
minvar1 = min(series1)-.01*abs(min(series1));
minvar2 = min(series2)-.01*abs(min(series2));
minvar = min(minvar1,minvar2);
plot(dt,series1,'-', 'Color', color5, 'MarkerSize',3, 'linewidth',2);
hold on
plot(dt,series2,'-', 'Color', color2, 'MarkerSize',3, 'linewidth',1);
plot(dt,zeros(T,1),'-', 'Color', color0, 'MarkerSize',3, 'linewidth',1);
hold off
title(char(titles(1)), 'fontsize', 10);
axis tight
ylim([minvar maxvar])
grid on
hh = legend('Actual data','HP trend','Location','NorthWest','Orientation','Horizontal');
set(hh,'box','off');

subplot(2,1,2)
series1 = log_y_hpfiltered;         % HP filtered data
maxvar = 1.05*max(max(series1),max(series1));
minvar1 = min(series1)-.05*abs(min(series1));
minvar = min(minvar1,minvar1);
plot(dt,series1,'-', 'Color', color8, 'MarkerSize',3, 'linewidth',3);
hold on
for ll=1:length(jp)
    area([dt(ip(ll)) dt(it(ll))],[0.99 0.99]*maxvar,minvar,'FaceColor',color17,'EdgeColor',color17)
end
plot(dt,zeros(T,1),'-', 'Color', color0, 'MarkerSize',3, 'linewidth',1);
plot(dt,series1,'-', 'Color', color8, 'MarkerSize',3, 'linewidth',3);
hold off
title(char(titles(2)), 'fontsize', 10);
axis tight
ylim([minvar maxvar])
hh = legend('Detrended data (HP)','Recession dates','Location','NorthEast','Orientation','Horizontal');
set(hh,'box','off');

figure(3)
set(gcf, 'Units', 'inches');
set(gcf, 'Position', [0 0 9.9 5.3]);
set(gcf, 'renderer', 'painters');
set(gcf, 'PaperPositionMode', 'auto');
% print(gcf, '-depsc2', '-painters', ['hp_trend.eps'])
% close

toc