function [ output ] = DNS_SSM( yields, lambda, tau, steps_ahead )
%DNS_SSM
[m, T] = size(yields);

%Initialize loadings
B = [ones(size(tau)), (1-exp(-lambda*tau))./(lambda*tau),...
    (1-exp(-lambda*tau))./(lambda*tau) - exp(-lambda*tau)];

beta = zeros(3,T);
residuals = zeros(m,T);

for t=1:T
    EstMdlOLS = fitlm(B, yields(:,t), 'Intercept', false);
    beta(:,t) = EstMdlOLS.Coefficients.Estimate;
    residuals(:,t) = EstMdlOLS.Residuals.Raw;
end

betas_adjusted = beta - mean(beta,1); %Intercept-adjusted betas

EstMdlVAR = estimate(varm(3,3), beta');

Mdl = ssm(@(params)SS_DieboldLi(params,yields,tau));

A0 = EstMdlVAR.AR{1};      % Get the VAR(1) matrix (stored as a cell array)
A0 = A0(:);                % Stack it columnwise
Q0 = EstMdlVAR.Covariance; % Get the VAR(1) estimated innovations covariance matrix
B0 = [sqrt(Q0(1,1)); 0; 0; sqrt(Q0(2,2)); 0; sqrt(Q0(3,3))];
H0 = cov(residuals);       % Sample covariance matrix of VAR(1) residuals
D0 = sqrt(diag(H0));       % Diagonalize the D matrix
mu0 = mean(beta)';
param0 = [A0; B0; D0; mu0; lambda];

options = optimoptions('fminunc','MaxFunEvals',25000,'algorithm','quasi-newton', ...
    'TolFun' ,1e-8,'TolX',1e-8,'MaxIter',1000,'Display','off');

[EstMdlSSM,params] = estimate(Mdl,yields,param0,'Display','off', ...
    'options',options,'Univariate',true);
b = 0;

end

