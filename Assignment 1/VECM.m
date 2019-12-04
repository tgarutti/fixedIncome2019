function [ output ] = VECM( yields, lambda, tau, steps_ahead )
% VECM returns forecasted yields using the vector error-correction model
% (1)

[m,T] = size(yields);
F = length(steps_ahead);
yield_forecasts = nan(m,F);

dY = yields(:,2:end) - yields(:,1:end-1);
beta = [-ones(1,m-1); eye(m-1)]; %cointegration relation
S = beta'*yields(:,1:end-1);
Z = [ones(1,T-1); S];
params = dY*Z'*inv(Z*Z'); %[mu; alpha]

for f=1:F
    Zf = [1; beta'*yields(:,end)];
    yields_f=yields(:,end);
    for s=1:steps_ahead(f)
        dyield = params*Zf;
        yields_f = yields_f + dyield;
        Sf = beta'*yields_f;
        Zf = [1;Sf];
    end
    yield_forecasts(:,f) = yields_f;
end

output = cell(1);
output{1} = yield_forecasts;

end
