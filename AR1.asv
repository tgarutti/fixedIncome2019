function [output] = AR1( yields, lambda, tau, steps_ahead )
% AR1 returns a forecasted yield of k steps ahead
[m, T] = size(yields);
F = length(steps_ahead);
yield_forecasts = nan(m,F);
X = yields(:,1:end-1);
Y = yields(:,2:end);
phi = nan(m,2);

for tau = 1:m
    phi(tau,:) = [ones(1,T-1);X(tau,:)]'\Y(tau,:)';
    for s = 1:F
        step = steps_ahead(s);
       yield_forecasts(tau, s) = phi(tau,1)*(1+sum(phi(tau,2).^[1:step-1]))+X(tau,end)*phi(tau,1)^step; 
    end
end

output = cell(1,1)
output{1} = yield_forecasts;

end