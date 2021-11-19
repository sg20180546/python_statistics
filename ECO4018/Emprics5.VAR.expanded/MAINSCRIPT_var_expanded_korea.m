%==========================================================================
%
% MAINSCRIPT_var_expanded_korea.m
% Main file to estimate VAR model for Korea
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
nlags = 3;          % VAR lag order
nsteps = 21;        % period for impulse responses

%% Load data and construct VAR variables
%===load data
X00 = xlsread('var_data_expanded_korea.xls');  % imported data should be in the same folder

X00_exo_temp = X00(2:end,1:3);          % exogenous variables, sample from 2000:Q1
X00_endo_temp = X00(2:end,4:end);       % endogenous variables, sample from 2000:Q1

%===construct variables for VAR
y_us = log(X00_exo_temp(:,1));          % logged US GDP
i_us = X00_exo_temp(:,2);               % US nominal interest rate
oil_price = log(X00_exo_temp(:,3));     % logged oil prices

y_kr = log(X00_endo_temp(:,1));         % logged Korean GDP
p_kr = log(X00_endo_temp(:,2));         % logged Korean CPI
i_kr = X00_endo_temp(:,3);              % Korean nominal interest rate
er_kr = log(X00_endo_temp(:,4));        % logged nominal exchange rate (won/dollar)

%% Construct VAR data
%EXO = [y_us i_us oil_price];            % exogenous variables
%EXO = [y_us i_us];
%EXO = [];

X = [y_kr p_kr i_kr er_kr];             % order of the endogenous variables: GDP, CPI, nominal interest rate and nominal exchange rate

YY = X(nlags+1:end,:);                  % VAR regressand

[TT,nvar] = size(YY);                   % TT: number of observations, nvar: numer of variables in the VAR model


lin_trend=(1:1:TT)';
EXO=[lin_trend lin_trend.^2];


XX00 = zeros(TT,nvar*nlags);            % XX00: VAR regressor without the constant term



for i=1:nlags
    XX00(:,nvar*(i-1)+1:nvar*i) = X(nlags-i+1:end-i,:);
end

%X_det = [ones(TT,1) EXO(nlags+1:end,:)];    % deterministic components of the VAR model
X_det = [ones(TT,1) EXO];    % deterministic components of the VAR model

n_det = size(X_det,2);                  % number of the deterministic components


XX = [X_det XX00];                      % XX: VAR regressor

%% VAR estimation using OLS
beta = inv(XX'*XX)*XX'*YY;              % VAR coefficients using OLS estimation

u = YY-XX*beta;                         % reduced-form residuals

sigma = u'*u/TT;                        % variance-covariance matrix

%% Identification of structural shocks using Cholesky
L = chol(sigma)';                       % chol gives upper triangular matrix

%% Construct VAR coefficient matrix for impulse responses
PI = beta(n_det+1:end,:)';
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

titles = {'Impulse response of GDP to a MP shock: Korea';
          'Impulse response of CPI to a MP shock';
          'Impulse response of nominal interest rate to a MP shock';
          'Impulse response of nominal exchange rate to a MP shock'};
      
figure(1)

for ii=1:4
    subplot(2,2,ii)
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

toc