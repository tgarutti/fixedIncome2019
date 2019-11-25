function [ output ] = summaryStatistics( yields )
%SUMMARYSTATISTICS
[m,T] = size(yields);

% Simple summary statistics
mu = mean(yields,2);
std_dev = std(yields')';
mi = min(yields')';
ma = max(yields')';

% Autocorrelations
lags = [1,12,30];
ac = zeros(m,30);
% for i=1:m
%     ac(i,:) = autocorr(yields(i,:), 30)';
% end
a1 = autocorr(yields(1,:),30);

end

