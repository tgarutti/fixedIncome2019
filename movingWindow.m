function [ output ] = movingWindow(w, yields, lambda, tau, steps_ahead, FUN )
%MOVINGWINDOW
for i=0:(size(yields, 2)-w-1)
    window = i:(i+w);
    yields_window = yields(:, window);
    
    output = 
end
output = FUN(yields, lambda, tau, steps_ahead);
end