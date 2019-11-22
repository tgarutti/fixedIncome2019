%% Assignment 1 - Main

%% Get data 
clc
clear
DATA = readtable('FinalDataMonthly10Y.csv');
tau = 12*[3/12, 6/12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]';
lambda = 0.0609;
yields = DATA{:,2:end}';
dates = DATA{:,1};
[m,T] = size(yields);

%% Plot yield curve
% surf(dates,tau,yields','FaceAlpha',0.75)
% ylabel('Maturity (years)');
% xlabel('Time');
% zlabel('Yield (%)');

%% DNS estimation (2-step), FULL SAMPLE
[DNS] = DNS_2step(yields, lambda, tau, [1]);

%% Dynamic Nelson-Siegel data generating process
R = 10;
yieldsSim = dgpDNS(tau, lambda, [1;1;1], 0.01, DNS{3}, 0.1, T, R);

%% SimulationLambda
lambda_in = [0.0001:0.0001:0.2];
[minCorr, maxB3, minMSE, simulations] = lambda_simStudy(yields, tau, ...
    lambda_in, false); %Set last variable to true for plots

%% DNS estimation (2-step), MOVING WINDOW

%Forecast: Dynamic Nelson-Siegel (2-step) using lambda = 0.0609
mwDNS_DiLi = movingWindow(50, yields, lambda, tau, [1,6,12], @DNS_2step);

%Forecast: Dynamic Nelson-Siegel (2-step) using lambda as min-correlation
mwDNS_Corr = movingWindow(50, yields, minCorr(1), tau, [1,6,12], @DNS_2step);

%Forecast: AR(1)
mwAR1 = movingWindow(50, yields, lambda, tau, [1,6,12], @AR1);

%Forecast: Random walk
mvRW = movingWindow(50, yields, lambda, tau, [1,6,12], @random_walk);
