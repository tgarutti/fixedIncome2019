%% Assignment 1 - Main

%% Get data 
clc
clear
DATA = readtable('FinalDataMonthly10Y.csv');
tau = 12*[3/12, 6/12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]';
lambda = 0.0609; %Diebold-Li (2006)
yields = DATA{:,2:end}';
dates = DATA{:,1};
[m,T] = size(yields);
mWindow = 75;

%% Plot yield curve
% surf(dates,tau,yields','FaceAlpha',0.75)
% ylabel('Maturity (years)');
% xlabel('Time');
% zlabel('Yield (%)');

%% Stationarity and Cointegration tests
preTests = preTestYields(yields, 5); % 5 lags

%% DNS estimation (2-step), FULL SAMPLE
[DNS] = DNS_2step(yields, lambda, tau, [1]);

%% Dynamic Nelson-Siegel data generating process
simulatedYields = dgpDNS(tau, lambda, [1;1;1], 0.01, DNS{3}, 0.1, T, 10);

%% Simulation study lambda
lambda_in = 0.0001:0.0001:0.2;
[minCorr, maxB3, minMSE, simulations] = lambda_simStudy(yields, tau, ...
    lambda_in, false); %Set last variable to true for plots

%% DNS estimation (2-step), MOVING WINDOW

%Forecast: Dynamic Nelson-Siegel (2-step) using lambda = 0.0609
mwDNS_DiLi = movingWindow(mWindow, yields, lambda, tau, [1,6,12], @DNS_2step);

%Forecast: Dynamic Nelson-Siegel (2-step) using lambda as min-correlation
mwDNS_Corr = movingWindow(mWindow, yields, minCorr(1), tau, [1,6,12], @DNS_2step);

%Forecast: Dynamic Nelson-Siegel (2-step) with time-varying lambda
mwDNS_timeVarying = movingWindow(mWindow, yields, lambda, tau, [1,6,12],...
    @timeVaryingDNS);

%Forecast: AR(1)
mwAR1 = movingWindow(mWindow, yields, lambda, tau, [1,6,12], @AR1);

%Forecast: VAR(1)
mwVAR1 = movingWindow(mWindow, yields, lambda, tau, [1,6,12], @VAR1);

%Forecast: Random walk
mwRW = movingWindow(mWindow, yields, lambda, tau, [1,6,12], @random_walk);

%% Estimation evaluation

% RMSFE: 1 month forecast length
RMSFE_1m = [mwRW{end}(:,1), mwAR1{end}(:,1), mwVAR1{end}(:,1), mwDNS_DiLi{end}(:,1),mwDNS_Corr{end}(:,1), mwDNS_timeVarying{end}(:,1)];

% RMSFE: 6 month forecast length

% RMSFE: 12 month forecast length
