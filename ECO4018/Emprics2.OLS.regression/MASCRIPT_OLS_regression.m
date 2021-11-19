%==========================================================================
%
% Mainscript_OLS_regression.m
% Main file to run OLS regression
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

X_0 = 0;                    % initial value for the AR process

%% Generate AR process with rho=0.5
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

%% OLS regression AR(2)
yvar = X_rho_5(3:end,1);                % regressand

T = size(yvar,1);                       % number of observation ("n" in the lecture slides)

xvar = [ones(T,1) X_rho_5(2:end-1,1) X_rho_5(1:end-2) ];  % regressor with a constant term
%xvar =  X_rho_5(1:end-1,1);  % regressor with a constant term
 
m = size(xvar,2);                      % number of regressors ("m" in the lecture slides)

betas = inv(xvar'*xvar)*xvar'*yvar;     % OLS estimates for the coefficients

residual = yvar - xvar*betas;           % OLS residuals

sigma_sq = (residual'*residual)/T;      % OLS estimate for sigma square

adj_r_sq = 1 - ((residual'*residual)/(T-m))/((yvar'*yvar)/(T-1));

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

dt = (1:1:T)';

figure(1)
subplot(2,1,1)
xval = xvar(:,2);	% x variable
yval = yvar;        % y variable
maxxval = max(xval)+0.1;
minxval = min(xval)-0.1;
maxyval = max(yval)+0.1;
minyval = min(yval)-0.1;
xdom = (minxval:0.01:maxxval)';
predicted_y = betas(1,1)*ones(size(xdom,1),1) + betas(2,1)*xdom;
plot(xdom,predicted_y,'-', 'Color', color20, 'MarkerSize',3, 'linewidth',1);
hold on
plot([0 0], [-100 100],'-', 'Color', color19, 'MarkerSize',3, 'linewidth',1)
plot([-100 100], [0 0],'-', 'Color', color19, 'MarkerSize',3, 'linewidth',1)
plot(xdom,predicted_y,'-', 'Color', color20, 'MarkerSize',3, 'linewidth',1);
scatter(xval,yval,12,'MarkerEdgeColor',color23,'MarkerFaceColor',color23);
hold off
axis tight
xlim([minxval maxxval])
ylim([minyval maxyval])
title('Scatter plot', 'fontsize', 10);
ylabel('Current value of the AR(1) process', 'fontsize', 10);
xlabel('Lagged value of the AR(1) process', 'fontsize', 10);

subplot(2,1,2)
series1 = residual;
maxvar = 1.01*max(max(series1),max(series1));
minvar1 = min(series1)-.01*abs(min(series1));
minvar = min(minvar1,minvar1);
plot(dt,series1,'-', 'Color', color3, 'MarkerSize',3, 'linewidth',1);
hold on
plot(dt,zeros(T,1),'-', 'Color', color0, 'MarkerSize',3, 'linewidth',1);
hold off
axis tight
ylim([minvar maxvar])
title('OLS residual', 'fontsize', 10);
grid on

figure(1)
set(gcf, 'Units', 'inches');
set(gcf, 'Position', [0 0 9.8 6.3]);
set(gcf, 'renderer', 'painters');
set(gcf, 'PaperPositionMode', 'auto');
% print(gcf, '-depsc2', '-painters', ['ar1_example.eps'])
% close

toc