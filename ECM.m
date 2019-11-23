function [ output ] = ECM(yields, lambda, tau, steps_ahead)
% ECM forecasts yields using the error-correction model

[m,T] = size(yields);
F = length(steps_ahead);
yield_forecasts = nan(m,F);
dyield = nan(m,F);

for tau=1:m
    % Estimate cointegration relation of yield_t and yield_(t-1)
    X = [ones(T-1,1),yields(tau,1:end-1)'];
    Y = yields(tau,2:end)';
    b = X\Y;
    
    % Estimate error-correction model
    error = Y - X*b;
    dX = [yields(tau,1:end-2) - yields(tau, 2:end-1)]';
    Z = [dX, error(1:end-1)]; 
    dY = [yields(tau,3:end) - yields(tau, 2:end-1)]';
    PHI = Z\dY; %PHI = [phi; gamma]
    
    % forecast yield
    Z = [yields(tau,end)-yields(tau,end-1), error(end)];
    for f=1:F
        dyield(tau,f) = Z*PHI;
        yield_forecasts(tau,f) = yields(tau,end) + dyield(tau,f);
        Z = [dyield(tau,f), error(end)*(1+PHI(2))^f];
    end 
end

output = cell(1);
output{1} = yield_forecasts;

end

