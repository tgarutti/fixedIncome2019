function [ output ] = movingWindow(w, yields, lambda, tau, steps_ahead, FUN )
%MOVINGWINDOW
%Initialize variables
[M,T] = size(yields);
S = numel(steps_ahead);
forecasts = cell(S,1);
for s=1:S
    forecasts{s} = zeros(M,T-w);
end

%Forecast yields over moving window
for i=1:(T-w)
    window = i:(i+w-1);
    yields_window = yields(:, window);
    
    model = FUN(yields_window, lambda, tau, steps_ahead);
    for s=1:S
        forecasts{s}(:,i) = model{1}(:,s);
    end
end

%Compute RMSFE
RMSFE = zeros(M,S);
output = cell(S+1,1);

for s=1:S
    step = steps_ahead(s);
    actuals = yields(:,(w+step):end);
    forecast_s = forecasts{s}(:,1:(end-step));
    RMSFE(:,s) = mean(sqrt((actuals-forecast_s).^2),2);
    output{s} = forecasts{s};
end

output{S+1} = RMSFE;

end