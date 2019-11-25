function [ output ] = evaluateSimulations( simYields, lambda, tau, steps_ahead, FUN )
%EVALUATESIMULATIONS
[R,~] = size(simYields);
output = cell(3,R);
for r=1:R
    yields = simYields{r};
    model = FUN(yields, lambda, tau, steps_ahead);
    output{2,r} = model{2};
    output{3,r} = model{3};
    output{3,r} = model{3};
end
end

