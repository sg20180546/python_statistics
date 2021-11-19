%==========================================================================
%
% MAINSCRIPT_var.m
% Main file to estimate VAR model
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

%% Select country
country_flag = 2;   % 1: US, 2: Korea

%% Overall setting
nlags = 3;          % VAR lag order
nsteps = 21;        % period for impulse responses

%% Load data and construct VAR variables
%===load data
X00 = xlsread('var_data.xls');  % imported data should be in the same folder

if country_flag==1
    X00 = X00(:,1:3);
elseif  country_flag==2
    X00 = X00(:,4:end);
end

%===construct variables for VAR
y_growth = (log(X00(2:end,1))-log(X00(1:end-1,1)))*100;     % calculate GDP growth
inflation = (log(X00(2:end,2))-log(X00(1:end-1,2)))*100;    % calculate inflation rate
interest_rate = X00(2:end,3);

%% Construct VAR data
X = [y_growth inflation interest_rate]; % order of the variables: output growth, inflation and nominal interest rate

YY = X(nlags+1:end,:);                  % VAR regressand

[TT,nvar] = size(YY);                   % TT: number of observations, nvar: numer of variables in the VAR model
    
XX00 = zeros(TT,nvar*nlags);            % XX00: VAR regressor without the constant term

for i=1:nlags
    XX00(:,nvar*(i-1)+1:nvar*i) = X(nlags-i+1:end-i,:);
end

XX = [ones(TT,1) XX00];                 % XX: VAR regressor

%% VAR estimation using OLS
beta = inv(XX'*XX)*XX'*YY;              % VAR coefficients using OLS estimation

u = YY-XX*beta;                         % reduced-form residuals

sigma = u'*u/TT;                        % variance-covariance matrix

%% Identification of structural shocks using Cholesky
L = chol(sigma)';                       % chol gives upper triangular matrix

%% Construct VAR coefficient matrix for impulse responses
PI = beta(2:end,:)';
if nlags > 1
    nsub = size(PI,2)-nvar;
    prePi = [eye(nsub) zeros(nsub,nvar)];
    PI = [PI; prePi];                   % big PI, VAR(1) representation of VAR(p)
end

%% Impulse responses
shock = 3;                              % shock of interest (3rd variable)

irf = zeros(nsteps,nvar);               % matrix storing impulse response
temp = eye(nvar*nlags);
  
for i=1:nsteps
    temp2 = temp(1:nvar,1:nvar)*L;
    irf(i,:) = temp2(:,shock)';
    temp = temp*PI;
end

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

dt = (0:1:nsteps-1)';

if country_flag==1
    titles = {'Impulse response of GDP growth to a monetary policy shock: US';
              'Impulse response of inflation to a monetary policy shock';
              'Impulse response of nominal interest rate to a monetary policy shock'};
elseif country_flag==2
    titles = {'Impulse response of GDP growth to a monetary policy shock: Korea';
              'Impulse response of inflation to a monetary policy shock';
              'Impulse response of nominal interest rate to a monetary policy shock'};
end
      
figure(1)

for ii=1:3
    subplot(3,1,ii)
    series1 = irf(:,ii);
    maxvar = 1.01*max(max(series1),max(series1));
    minvar1 = min(series1)-.01*abs(min(series1));
    minvar = min(minvar1,minvar1);
    plot(dt,series1,'-', 'Color', color2, 'MarkerSize',3, 'linewidth',2);
    hold on
    plot(dt,zeros(nsteps,1),'-', 'Color', color0, 'MarkerSize',3, 'linewidth',1);
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

if country_flag==1
    titles = {'Impulse response of GDP to a monetary policy shock: US';
              'Impulse response of price to a monetary policy shock';
              'Impulse response of nominal interest rate to a monetary policy shock'};
elseif country_flag==2
    titles = {'Impulse response of GDP to a monetary policy shock: Korea';
              'Impulse response of price to a monetary policy shock';
              'Impulse response of nominal interest rate to a monetary policy shock'};
end

figure(2)

for ii=1:3
    subplot(3,1,ii)
    if ii<=2
        series1 = cumsum(irf(:,ii));
    else
        series1 = irf(:,ii);
    end
    maxvar = 1.01*max(max(series1),max(series1));
    minvar1 = min(series1)-.01*abs(min(series1));
    minvar = min(minvar1,minvar1);
    plot(dt,series1,'-', 'Color', color2, 'MarkerSize',3, 'linewidth',2);
    hold on
    plot(dt,zeros(nsteps,1),'-', 'Color', color0, 'MarkerSize',3, 'linewidth',1);
    hold off
    axis tight
    ylim([minvar maxvar])
    title(char(titles(ii)), 'fontsize', 10);
    grid on
end

figure(2)
set(gcf, 'Units', 'inches');
set(gcf, 'Position', [0 0 9.8 6.3]);
set(gcf, 'renderer', 'painters');
set(gcf, 'PaperPositionMode', 'auto');
% print(gcf, '-depsc2', '-painters', ['ar1_example.eps'])
% close

toc