%==========================================================================
%
% MAINSCRIPT_var_expanded_korea_sign.m
% Main file to run a VAR with sign restrictions
%
%                                Author: Joonyoung Hur (joonyhur@gmail.com)
%                                    School of Economics, Sogang Univeristy
%==========================================================================

clc;
format short g;
close all;
clear all;

tic

rand('state',26);
randn('state',26);

%% Data loading
X00 = xlsread('var_data_expanded_korea.xls');  % imported data should be in the same folder

X00_endo_temp = X00(2:end,4:end);       % endogenous variables, sample from 2000:Q1

y_kr = log(X00_endo_temp(:,1));         % logged Korean GDP
p_kr = log(X00_endo_temp(:,2));         % logged Korean CPI
i_kr = X00_endo_temp(:,3);              % Korean nominal interest rate
er_kr = log(X00_endo_temp(:,4));        % logged nominal exchange rate (won/dollar)

Y = [y_kr p_kr i_kr er_kr];             % endogenous variables, sample from 2000:Q1

%% VAR system setting
p = 3;                % number of lags
[n,nvar] = size(Y);   % n: # of total observations, nvar: # of variables
T = n-p;              % T: # of effective observations
k = nvar*p;           % k: # of coefficients to estimate in one equation
nstep = 21;           % # of IFR steps to compute

X = zeros(T,k);
for i=1:p
    X(:,(i-1)*nvar+(1:nvar)) = Y((p+1:end)-i,:);   % X (T x ml) matrix
end

c = 1;   % presence of trend components: no trend = 0; demean = 1; linear detrend = 2; quadratic detrend = 3
lin_trend = (1:1:T)';
X = [ones(T,1) X];

%% OLS estimation
%==========================================================================
% Model: Y = XB+U
%        where Y:Txm, X:Txml, B:mlxm, and U:Txm (m=nvar)
%==========================================================================
Y = Y(1+p:end,:);
PI = inv(X'*X)*X'*Y;   % B matrix in the paper
u = Y - X*PI;
Omega = (u'*u)/(T-k);  % Omega = (u'*u)/T;

%% Finding posterior parameters
% Prior: Conjugate prior (Normal Inverted-Wishart)
nu0 = 0;                                 % nu: a scalar
N0 = zeros(size(X'*X,1),size(X'*X,2));   % N: ml x ml
S0 = eye(nvar);                          % S: m x m
B0 = zeros(nvar*p+c,nvar);               % B: ml x m

% Posterior parameters
nu = nu0 + T;
N = N0 + X'*X;
B = inv(N)*(N0*B0 + X'*X*PI);
S = nu0/nu*S0 + T/nu*Omega + 1/nu*(PI-B0)'*N0*inv(N)*(X'*X)*(PI-B0);

%% Draws of B and Sigma matrices from the posterior distribution
ndraws = 1000;

for d=1:ndraws
    Sigma(:,:,d) = wishrnd(inv(S)/nu,nu);
    Sigma(:,:,d) = inv(Sigma(:,:,d));   % Draw Sigma from the posterior
    
    krons = kron(Sigma(:,:,d),inv(N));
    krons = krons/2 + krons'/2;
    vecB(:,d) = mvnrnd(vec(B),krons,1)';
    Bet(:,:,d) = vec_to_mat(vecB(:,d),p,nvar,c,1); % Draw B from the posterior
end

%% Cholesky Impulse Responses
for d=1:ndraws
    BB = [Bet(:,c+1:end,d); eye(nvar*p-nvar) zeros(nvar*p-nvar,nvar)];
    for j=1:nstep
        if j == 1 %% compute Wold Impulses
            wimpu(:,:,j) = eye(size(BB,1),size(BB,2));
        elseif j > 1
            wimpu(:,:,j) = BB^(j-1);
        end
        woldimp(:,:,j,d) = wimpu(1:nvar,1:nvar,j);
        %% Compute Cholesky Impulse response functions
        cimpu(:,:,j) = wimpu(1:nvar,1:nvar,j)*chol(Sigma(:,:,d))';
        choleskyimp(:,:,j,d) = cimpu(:,:,j);
        % choleskyimp(p,q,j,d): j-th period response of
        %         q-th structural innovation to p-th variable at d-th draw
    end
end

%% Drawing alpha and finding IRFs matching sign restrictions
maxdraws = 1000;

Kmax = 2;   % maximum period of sign restrictions

dr = 0;
d = 0;

drmp = 0;

% Shock identification

MPshock = [];
imprand = [];  % random number for impulse responses

while d < maxdraws
    
    ext = fix(size(choleskyimp,4)*rand(1,1))+1;   % random # in [1,ndraws]
    condi = 1;
    dr = dr + 1;
    
    % MP shock
    
    premps = normrnd(0,1,[nvar,1]);
    premps = premps/norm(premps);
    for j=1:Kmax+1
        ikmps = choleskyimp(:,:,j,ext)*premps;
        if ikmps(1)>0 || ikmps(2)>0 || ikmps(3)<0
         % if any of the sign restrictions is violated ('or' statement)
           condi = 0;
           
           drmp = drmp + 1;
        end
    end
    
    if condi == 1
        d = d+1;
        MPshock = [MPshock premps];
        imprand = [imprand; ext];
        disp ('...Restrictions are satistied...')
        disp (d)
    end
end

%% Impuse response functions

for d=1:ndraws
    for j=1:nstep
        impres(j,:,d) = (choleskyimp(:,:,j,imprand(d))*MPshock(:,d))';
    end
end

pereb = 0.16;   % percentage of error bands

for i=1:nstep
    for j=1:nvar
        upimpres(i,j) = quantile(impres(i,j,1:end),1-pereb);
        medimpres(i,j) = median(impres(i,j,1:end));
        downimpres(i,j) = quantile(impres(i,j,1:end),pereb);
    end
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
color16 = rgb('DimGray');
color17 = rgb('LightGray');
color18 = rgb('Gold');
color19 = rgb('DarkGray');
color20 = rgb('SkyBlue');
color21 = rgb('LightCoral');
color22 = rgb('DodgerBlue');

dt = (0:1:nstep-1)';

%===Highlight sign restrictions
through = zeros(size(dt,1),1);
through(Kmax+1) = 1;

peak = zeros(size(dt,1),1);
peak(1) = 1;

[it,jt]=find(through);
[ip,jp]=find(peak);

figure(1)
for ii=1:nvar
    subplot(2,2,ii)
    series1 = medimpres(1:nstep,ii);    % median
    series2 = downimpres(1:nstep,ii);	% low 16 pct
    series3 = upimpres(1:nstep,ii);     % up 84 pct
    maxvar = 1.1*max(max(series1),max(series3));
    if maxvar<0
        maxvar = 0;
    end
    minvar1 = min(series1)-.1*abs(min(series1));
    minvar2 = min(series2)-.1*abs(min(series2));
    minvar = min(minvar1,minvar2);
    plot(dt,series1,'-', 'Color', color0, 'MarkerSize',3, 'linewidth',2);
    hold on;
    plot(dt,series2,'--', 'Color', color2, 'MarkerSize',3, 'linewidth',2);
    plot(dt,series3,'--', 'Color', color2, 'MarkerSize',3, 'linewidth',2);
    if ii<=3
        area([dt(ip(1)) dt(it(1))],[maxvar maxvar],minvar,'FaceColor',[ 0.75 0.75 0.75 ],'EdgeColor',[ 0.75 0.75 0.75 ])
    end
    plot(dt,series1,'-', 'Color', color0, 'MarkerSize',3, 'linewidth',2);
    plot(dt,series2,'--', 'Color', color2, 'MarkerSize',3, 'linewidth',2);
    plot(dt,series3,'--', 'Color', color2, 'MarkerSize',3, 'linewidth',2);
    plot(dt,zeros(nstep,1),'-k','LineWidth',1);
    hold off;
    if ii==1
        title ('GDP');
    elseif ii==2
        title ('CPI');
    elseif ii==3
        title ('Nominal interest rate');
    elseif ii==4
        title ('Nominal exchange rate');
    end
%     xlabel('Years after the shock')
%     ylabel('Percent')
    xlim([0 nstep])
    axis tight
    ylim([minvar maxvar])
    xticks([0 4 8 12 16 20])
end

figure(1)
set(gcf, 'Units', 'inches');
set(gcf, 'Position', [0 0 10 5]);
set(gcf, 'renderer', 'painters');
set(gcf, 'PaperPositionMode', 'auto');
% print(gcf, '-depsc2', '-painters', ['korea_mp_sign.eps'])
% close

toc