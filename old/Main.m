%% Assignment 1 - Main interface

%% Get data 
clc
clear
DATA = readtable('FinalDataMonthly10Y.csv');
tau = [3/12, 6/12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]';
yields = DATA{:,2:end};
dates = DATA{:,1};

%% Plot yield curve
% surf(dates,tau,yields','FaceAlpha',0.75)
% ylabel('Maturity (years)');
% xlabel('Time');
% zlabel('Yield (%)');

%% Define prior parameters
T = max(size(yields));
IS = floor(T/2);
OOS = T - IS;
lambda_DL = 0.0609;

%% Estimate and forecast yields

[betas_DL_IS, betas_DL_OOS, PHI_IS, PHI_OOS, yields_DL_IS, yields_DL_F, errors_DL_IS, errors_DL_betas_IS] = DNS(yields, tau, lambda_DL, T, IS, OOS);
lambda_opt = optimise_lambda(yields, betas_DL_IS, tau, 12000);


%% Forecast evaluation
R2_DL_F = calculate_R2_OOS(yields_DL_F(:,2),yields(60:end,2));
MSPE_DL_F = calculate_MSPE(yields, yields_DL_F);

%% DNS estimation and forecasting
function [betas_IS, betas_OOS, PHI_IS, PHI_OOS, yields_IS, yields_F, errors_IS, errors_betas_IS] = DNS(yields, tau, lambda, T, IS, OOS);

% IS cross-sectional Nelson-Siegel betas
L1 = ones(length(tau),1);
L2 = (1-exp(-lambda.*tau))./lambda.*tau;
L3 = L2 - exp(-lambda.*tau);
B = [L1, L2 , L3];
betas_IS = nan(3,T);
yields_IS = nan(size(yields,1),size(yields,2));
for t=1:T
betas_IS(:,t) = B\yields(t,:)';
yields_IS(t,:) = B*betas_IS(:,t);
end
errors_IS = yields - yields_IS;

% VAR(1) over entire sample
X = [ones(1,T-1); betas_IS(:,1:end-1)];
Y = betas_IS(:,2:end);
PHI_IS = Y*X'*inv(X*X');
errors_betas_IS = betas_IS(:,2:end) - PHI_IS*X;

%OOS forecast of betas and yields
betas_OOS = nan(3,T-IS);
PHI_OOS = nan(3,4,T-IS);
yields_F = nan(T-IS,length(tau));
for f=0:OOS 
    X_VAR = [ones(1,IS-1); betas_IS(:,1+f:IS-1+f)];
    Y_VAR = betas_IS(:,2+f:IS+f);
    PHI_OOS(:,:,1+f) = Y_VAR*X_VAR'*inv(X_VAR*X_VAR');
    betas_OOS(:,1+f) = PHI_OOS(:,:,1+f)*[1;betas_IS(:,IS+f)];
    yields_F(1+f,:) = B*betas_OOS(:,1+f);
end

end

%% DNS lambda optimisation
function [lambda_out] = optimise_lambda(yields, betas, tau, lambda_in)
%OPTIMISE_LAMBDA returns the lambda for which the obj_func is minimised
options = optimoptions(@fminunc, 'TolFun', 1e-10) % more stringent optimality condition
lambda_out = fminunc(@(lambda_in)DNS_obj_func(yields, betas, tau, lambda_in), lambda_in);
end

function [SSE] = DNS_obj_func(yields, betas, tau, lambda_in)
%DNS_OBJ_FUNC returns the sum of squared errors of the DNS model

L1 = ones(length(tau),1);
L2 = (1-exp(-lambda_in.*tau))./lambda_in.*tau;
L3 = L2 - exp(-lambda_in.*tau);
SSE=0;
for t = 1:max(size(yields))
 SSE = SSE + sum((yields(t,:)'-betas(1,t)*L1-betas(2,t)*L2-betas(3,t)*L3).^2) ;
end

end


%% State-Space model for Diebold Li

%% MSPE calculation
function [MSPE] = calculate_MSPE(Y, Yhat)
% CALCULATE_MSPE calculates the mean squared prediction error

errors = Yhat - Y(size(Y,1)-size(Yhat,1)+1:end,:);
MSPE = mean(errors.^2);

end

function [Roos] = calculate_R2_OOS(Y,Yhat);
%CALCULATE_R2_OOS calculates the out-of-sample R squared statistic
%of Campbell and Thompson (2008) for a vector

% Check if both inputs are row vectors
if isrow(Y) < 1
    Y = Y';
end
if isrow(Yhat) < 1
    Yhat = Yhat';
end

Toos = length(Yhat);
SSR = sum((Y(end-Toos+1:end)-Yhat).^2);
SST = sum((Y(end-Toos+1:end)-...
    repmat(mean(Y(end-Toos+1:end)),[1 Toos])).^2);
Roos = 1 - SSR/SST;
end
