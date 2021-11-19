%==========================================================================
%
% Mainscript_AR_process.m
% Main file to simulate AR processes
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

%% Overall setting
ntotal = 200;               % total number of periods to generate data
nburnin = 100;              % number of periods for initial burn-in
nsimper = ntotal - nburnin;	% number of simulation periods

X_0 = 0;                    % initial value for the AR processes

%% Generate AR process, with rho=0.1
rho = 0.1;  % autocorrelation parameter

shocks = randn(ntotal,1);   % random draws for shocks from the standard normal distribution

X = zeros(ntotal,1);

for i=1:ntotal
    if i==1
        X(i,1) = rho*X_0 + shocks(i,1);
    else
        X(i,1) = rho*X(i-1,1) + shocks(i,1);
    end
end

X_rho_1 = X( nburnin+1:end , :);

%% Generate AR process, with rho=0.5
rho = 0.5;  % autocorrelation parameter

shocks = randn(ntotal,1);   % random draws for shocks from the standard normal distribution

X = zeros(ntotal,1);

for i=1:ntotal
    if i==1
        X(i,1) = rho*X_0 + shocks(i,1);
    else
        X(i,1) = rho*X(i-1,1) + shocks(i,1);
    end
end

X_rho_5 = X(nburnin+1:end,:);

%% Generate AR process, with rho=0.9
rho = 0.9;  % autocorrelation parameter

shocks = randn(ntotal,1);   % random draws for shocks from the standard normal distribution

X = zeros(ntotal,1);

for i=1:ntotal
    if i==1
        X(i,1) = rho*X_0 + shocks(i,1);
    else
        X(i,1) = rho*X(i-1,1) + shocks(i,1);
    end
end

X_rho_9 = X(nburnin+1:end,:);

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

dt = (1:1:nsimper)';

titles = {'AR(1) process with \rho=0.1';
          'AR(1) process with \rho=0.5';
          'AR(1) process with \rho=0.9';
          'AR(1) processes: comparison'};
      
figure(1)

for ii=1:3
    subplot(3,1,ii)
    if ii==1
        series1 = X_rho_1(:,1);
    elseif ii==2
        series1 = X_rho_5(:,1);
    elseif ii==3
        series1 = X_rho_9(:,1);
    end
    maxvar = 1.01*max(max(series1),max(series1));
    minvar1 = min(series1)-.01*abs(min(series1));
    minvar = min(minvar1,minvar1);
    plot(dt,series1,'-', 'Color', color5, 'MarkerSize',3, 'linewidth',1);
    hold on
    plot(dt,zeros(nsimper,1),'-', 'Color', color0, 'MarkerSize',3, 'linewidth',1);
    hold off
    axis tight
    ylim([minvar maxvar])
    title(char(titles(ii)), 'fontsize', 10);
    grid on
end

figure(1)
set(gcf, 'Units', 'inches');
set(gcf, 'Position', [0 0 9.8 6.3]);
set(gcf, 'renderer', 'painters');
set(gcf, 'PaperPositionMode', 'auto');
% print(gcf, '-depsc2', '-painters', ['ar1_example.eps'])
% close        

toc