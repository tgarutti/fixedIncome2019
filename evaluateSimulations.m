function [ output ] = evaluateSimulations( simYields, lambda, tau, steps_ahead, FUN1, lambdaCorr, FUN3 )
%EVALUATESIMULATIONS
[R,~] = size(simYields);
[m,T] = size(simYields{1});
output = cell(3,1);
summaryStats = zeros(m,6,R);
beta = zeros(3,T,3,R);
phi = zeros(3,4,3,R);
for r=1:R
    yields = simYields{r};
    model1 = FUN1(yields, lambda, tau, steps_ahead);
    model2 = FUN1(yields, lambdaCorr, tau, steps_ahead);
    model3 = FUN3(yields, lambda, tau, steps_ahead);
    beta(:,:,1,r) = model1{2};
    phi(:,:,1,r) = model1{3};
    beta(:,:,2,r) = model2{2};
    phi(:,:,2,r) = model2{3};
    beta(:,:,3,r) = model3{2};
    phi(:,:,3,r) = model3{3};
    summaryStats(:,:,r) = summaryStatistics(yields);
end
output{1} = summaryStats;
output{2} = beta;
output{3} = phi;

end

