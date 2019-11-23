function [output] = VAR1( yields, lambda, tau, steps_ahead )
% VAR1 forecasts yields using a VAR(1) model

[m,T] = size(yields);
F = length(steps_ahead);
yield_forecasts = nan(m,F);

% estimate VAR(1) parameters
Y = yields(:,2:end);
X = [ones(1,T-1);yields(:,1:end-1)];
PHI = Y*X'*inv(X*X');

% evaluating forecasts for different lengths
for f=1:F
    y = yields(:,end);
    step = steps_ahead(f);
    % recursive forecasting until forecast length is reached
    for s=1:f
        y = PHI*[1;y];
    end
    yield_forecasts(:,f) = y;
end

output = cell(1);
output{1} = yield_forecasts;
end