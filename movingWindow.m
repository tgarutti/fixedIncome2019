function [ output ] = movingWindow(w, yields, lambda, tau, steps_ahead, FUN )
%MOVINGWINDOW

[M,T] = size(yields);
S = numel(steps_ahead);
forecasts = cell(S,1);
for s=1:S
    forecasts{s} = zeros(M,T-w);
end

for i=1:(T-w)
    window = i:(i+w-1);
    yields_window = yields(:, window);
    
    model = FUN(yields_window, lambda, tau, steps_ahead);
    for s=1:S
        forecasts{s}(:,i) = model{1}(:,s);
    end
end

output = forecasts;
end