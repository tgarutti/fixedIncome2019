function [ output ] = DNS_2step( yields, lambda, tau, steps_ahead )
%DNS_2STEP
[m, T] = size(yields);

%Initialize Beta and B loadings
B = [ones(size(tau)), (1-exp(-lambda*tau))./(lambda*tau),...
    (1-exp(-lambda*tau))./(lambda*tau) - exp(-lambda*tau)];
beta = zeros(3,T);

%Estimate betas for each t by cross-sectional OLS
for t=1:T
    beta(:,t) = B\yields(:,t);
end

%Estimate VAR(1) model for betas
Y = beta(:,2:end);
X = [ones(1, T-1) ;beta(:,1:end-1)];
phi = Y*X' * inv(X*X');

%Forecast using DNS model
F = size(steps_ahead,2);
yield_forecasts = zeros(m,F);
beta_forecasts = zeros(3,F);
for f=1:F
    b = beta(:,end);
    step = steps_ahead(f);
    for s=1:step
        b = phi*[1;b];
    end
    yield_forecasts(:,f) = B*b;
    beta_forecasts(:,f) = b;
end

output = cell(3,1);
output{1} = yield_forecasts;
output{2} = beta;
output{3} = phi;

end