function [yield_forecasts] = random_walk( yields, lambda, tau, steps_ahead )
% RANDOM_WALK returns a random walk forecasted yield of k steps ahead
F = length(steps_ahead);
yield_forecasts = repmat(yields(:,end),[1,F]);
end