function [ minCorr, maxB3, minMSE, simulations ] = lambda_simStudy( yields, tau, lambda_in, plotBool)
%LAMBDA_SIMSTUDY
[m,T] = size(yields);
[DNS] = DNS_2step(yields, 0.0609, tau, []);
betasFull = DNS{1};
%Optimize lambda for min correlation, min MSE and max curvature loading
funCorr = @(lambda_in)abs(corr((1-exp(-tau*lambda_in))./(tau*lambda_in),...
    (1-exp(-tau*lambda_in))./(tau*lambda_in) - exp(-tau*lambda_in)));
funB3 = @(lambda_in)-1*((1-exp(-30*lambda_in))/(30*lambda_in)...
    - exp(-30*lambda_in));
funErr = @(lambda_in)sum(sum((yields - [ones(size(tau)),...
    (1-exp(-lambda_in*tau))./(lambda_in*tau),(1-exp(-lambda_in*tau))./...
    (lambda_in*tau) - exp(-lambda_in*tau)] * betasFull).^2, 1), 2)/m/T;

%Set initial parameters
lambda0 = 0.1;
A = [];
b = [];
Aeq = [];
beq = [];
lb = 0.0001;
ub = 2;
nonlcon = [];
options = optimoptions('fmincon', 'TolFun', 1e-10);

[lambda_Corr, fvalCorr] = fmincon(funCorr, lambda0, A, b, Aeq, beq, lb,...
    ub, nonlcon, options);
minCorr = [lambda_Corr, fvalCorr];
[lambda_B3, fvalB3] = fmincon(funB3, lambda0, A, b, Aeq, beq, lb,...
    ub, nonlcon, options);
maxB3 = [lambda_B3, -fvalB3];
[lambda_Err, fvalMSE] = fmincon(funErr, lambda0, A, b, Aeq, beq, lb,...
    ub, nonlcon, options);
minMSE = [lambda_Err, fvalMSE];

%Simulation: correlation between slope and curvature loadings (and MSE)
n = size(lambda_in,2);
B2 = (1-exp(-tau*lambda_in))./(tau*lambda_in);
B3 = (1-exp(-tau*lambda_in))./(tau*lambda_in) - exp(-tau*lambda_in);
B3_30 = (1-exp(-30*lambda_in))./(30*lambda_in) - exp(-30*lambda_in);

corrB2B3 = zeros(size(lambda_in));
MSE = zeros(size(lambda_in));
for i=1:n
    corrB2B3(i) = corr(B2(:,i),B3(:,i));
    MSE(i) = sum(sum((yields - [ones(size(tau)),(1-exp(-lambda_in(i)...
        *tau))./(lambda_in(i)*tau),(1-exp(-lambda_in(i)*tau))./...
        (lambda_in(i)*tau) - exp(-lambda_in(i)*tau)]...
        * betasFull).^2, 1), 2)/m/T;
end

simulations = [corrB2B3', B3_30', MSE'];

%Plot simulation study
if (plotBool == true)
    plot(lambda_in, corrB2B3);
    ylabel('Correlation between slope and curvature loadings');
    xlabel('Lambda');
    hold on 
    plot(lambda_in, B3_30);
    ylabel('Value of curvature loading');
    xlabel('Lambda');
    hold on 
    plot(lambda_in, MSE);
    ylabel('In-sample MSE');
    xlabel('Lambda');
end
end