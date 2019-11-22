function [ output ] = timeVaryingDNS( yields, lambda, tau, steps_ahead )
%TIMEVARYINGDNS
[m,T] = size(yields);

%Estimate betas given initial lambda
outputDNS = DNS_2step(yields, lambda, tau, steps_ahead);
betas = outputDNS{2};

%Optimize lambda based on the estimated betas
funErr = @(lambda_in)sum(sum((yields - [ones(size(tau)),...
    (1-exp(-lambda_in*tau))./(lambda_in*tau),(1-exp(-lambda_in*tau))./...
    (lambda_in*tau) - exp(-lambda_in*tau)] * betas).^2, 1), 2)/m/T;

lambda0 = 0.1;
A = [];
b = [];
Aeq = [];
beq = [];
lb = 0.0001;
ub = 2;
nonlcon = [];
options = optimoptions('fmincon', 'TolFun', 1e-10);

[optLambda, ~] = fmincon(funErr, lambda0, A, b, Aeq, beq, lb,...
    ub, nonlcon, options);

output = DNS_2step(yields, optLambda, tau, steps_ahead);
end

