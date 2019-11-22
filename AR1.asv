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
       yield_forecasts(tau, s) = (1+sum(phi(tau,1).^[1:s]))+X(tau,end)*phi(tau,1)^s; 
    end
end

end