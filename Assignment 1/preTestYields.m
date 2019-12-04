function [output] = preTestYields(yields, lags)
%ADFTESTYIELDS performs the ADF stationarity test and Engle-Granger
%cointegration test

[m,T] = size(yields);
L = length(lags);
IsStationary = nan(m,L); 
IsCointegrated = nan(m,1); 
pValue_ADF = nan(m,L);
pValue_EG = nan(m,1);

% perform tests
for s = 1:m
    % ADF: 1 indicates stationarity | last input is most recent observation
    [IsStationary(s,:), pValue_ADF(s,:)] = adftest(yields(s,:),'lags',lags); 
    
    % EGCI: 1 indicates cointegration | last input is most recent observation
    [IsCointegrated(s,:), pValue_EG(s,:)] = egcitest(([yields(s,2:end);yields(s,1:end-1)])', 'lags', max(lags));
end

output = cell(2,2);
output{1,1} = IsStationary;
output{1,2} = pValue_ADF;
output{2,1} = IsCointegrated;
output{2,2} = pValue_EG;

end