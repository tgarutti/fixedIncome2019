function [output] = random_walk( yields, lambda, tau, steps_ahead )
% RANDOM_WALK returns a random walk forecasted yield of k steps ahead
F = length(steps_ahead);

yield_forecasts = repmat(yields(:,end),[1,F]);
output = cell(1,1);
output{1,1} = yield_forecasts;
end