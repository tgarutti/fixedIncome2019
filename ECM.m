function [ output ] = ECM(yields, lambda, tau, steps_ahead)
% ECM forecasts yields using the error-correction model 

[m,T] = size(yields);
F = length(steps_ahead);
yield_forecasts = nan(m,F);

for tau=1:m
    
X = [ones(T-1,1),yields(tau,1:end-1)'];
Y = yields(tau,2:end)';
b = X\Y;

% error %y-X'b
% dX 
% Z %[dX; error]
% dY 
% PHI = Z\dY; %[phi; gamma]

% for f=1:F
% yield_forecast(tau,f) = 
% end

end

% output = cell(1)
