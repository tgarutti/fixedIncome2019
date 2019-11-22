function [ forecasts ] = DNS_forecast( yields, beta, phi, lambda, tau, step_ahead )
%DNS_forecast
[~, T] = size(yields);
forecasts = zeros(size(tau,1), size(step_ahead, 2));

%Initialize B loadings
B = [ones(size(tau)), (1-exp(-lambda*tau))./(lambda*tau),...
    (1-exp(-lambda*tau))./(lambda*tau) - exp(-lambda*tau)];


end

