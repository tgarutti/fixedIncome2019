function [output] = VAR1( yields, lambda, tau, steps_ahead )
% VAR1 forecasts yields using a VAR(1) model

[m,T] = size(yields);
S = length(steps_ahead);
yield_forecasts = nan(m,S);

X = [ones(1,T-1);yields(:,1:end-1)];
Y = yields(:,2:end);
PHI = inv(X*X')*X*Y'

for s=1:S
    
    
end


end