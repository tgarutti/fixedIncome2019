function [ output ] = movingWindow( yields, lambda, tau, steps_ahead, FUN )
%MOVINGWINDOW

output = FUN(yields, lambda, tau, steps_ahead);
end