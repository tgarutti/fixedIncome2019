function [ output ] = summaryStatistics( yields )
%SUMMARYSTATISTICS
[m,T] = size(yields);

% Simple summary statistics
mu = mean(yields,2);
std_dev = std(yields')';
mi = min(yields')';
ma = max(yields')';

% Autocorrelations
lags = [1,12];
ac = zeros(m,lags(end)+1);
for i=1:m
    ac(i,:) = autocorr(yields(i,:), lags(end))';
end
ac = ac(:,1+lags);

output = [mu, std_dev, mi, ma, ac];
end

