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
R = 100;

%% Plot yield curve
% surf(dates,tau,yields','FaceAlpha',0.75)
% ylabel('Maturity (years)');
% xlabel('Time');
% zlabel('Yield (%)');

%% Stationarity and Cointegration tests
preTests = preTestYields(yields, 5); % 5 lags

%% DNS estimation (2-step), FULL SAMPLE
[DNS] = DNS_2step(yields, lambda, tau, 1);

%% Dynamic Nelson-Siegel data generating process
simulatedYields = dgpDNS(tau, lambda, [1;1;1], 0.01, DNS{3}, 0.1, T, R);

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

%Forecast: Random walk
mwRW = movingWindow(mWindow, yields, lambda, tau, [1,6,12], @random_walk);

%Forecast: AR(1)
mwAR1 = movingWindow(mWindow, yields, lambda, tau, [1,6,12], @AR1);

%Forecast: VAR(1)
mwVAR1 = movingWindow(mWindow, yields, lambda, tau, [1,6,12], @VAR1);

%Forecast: ECM(1)
mwECM = movingWindow(mWindow, yields, lambda, tau, [1,6,12], @ECM);

%Forecast: VECM(1)
mwVECM = movingWindow(mWindow, yields, lambda, tau, [1,6,12], @VECM);

%% Estimation evaluation

% RMSFE: 1 month forecast length
RMSFE_1m = [mwRW{end}(:,1), mwAR1{end}(:,1), mwVAR1{end}(:,1), ...
    mwECM{end}(:,1), mwVECM{end}(:,1), ...
    mwDNS_DiLi{end}(:,1), mwDNS_Corr{end}(:,1), mwDNS_timeVarying{end}(:,1)];

% RMSFE: 6 month forecast length
RMSFE_6m = [mwRW{end}(:,2), mwAR1{end}(:,2), mwVAR1{end}(:,2), ...
    mwECM{end}(:,2), mwVECM{end}(:,2), ...
    mwDNS_DiLi{end}(:,2), mwDNS_Corr{end}(:,2), mwDNS_timeVarying{end}(:,2)];

% RMSFE: 12 month forecast length
RMSFE_12m = [mwRW{end}(:,3), mwAR1{end}(:,3), mwVAR1{end}(:,3), ...
    mwECM{end}(:,3), mwVECM{end}(:,3), ...
    mwDNS_DiLi{end}(:,3), mwDNS_Corr{end}(:,3), mwDNS_timeVarying{end}(:,3)];

%% Model evaluation for simulated yields

DNS_sim = evaluateSimulations( simulatedYields, minCorr(1), tau, [1,6,12],...
    @DNS_2step);
meanStats = mean(DNS_sim{1},3);
[statsBeta, statsPhi] = statsPlots(DNS_sim, 0);
