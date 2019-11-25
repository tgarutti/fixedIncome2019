function [ output ] = evaluateSimulations( simYields, lambda, tau, steps_ahead, FUN)
%EVALUATESIMULATIONS
[R,~] = size(simYields);
[m,T] = size(simYields{1});
output = cell(3,1);
summaryStats = zeros(m,6,R);
beta = zeros(3,T,R);
phi = zeros(3,4,R);
for r=1:R
    yields = simYields{r};
    model = FUN(yields, lambda, tau, steps_ahead);
    beta(:,:,r) = model{2};
    phi(:,:,r) = model{3};
    summaryStats(:,:,r) = summaryStatistics(yields);
end
output{1} = summaryStats;
output{2} = beta;
output{3} = phi;

end

