%% Data Generating Process

%% Define initial parameters
T = 100;
R = 20;
c = [-0.023; 0.0193; -0.0163];
phi = [-2.41467059164452,-2.80740475575309,-0.343483533199631; ... 
    3.21990641198281,3.61127470938751,0.346911620958664;... 
    4.86112935443401,4.24333951736916,1.31583866824647];
% phi = diag([-2, 3.6, 1.3]);
var1 = 0.03;
sigma = 0.1;


% DNS values
tau = [3, 6, 9, 12, 24, 36, 48, 60, 84, 120]/12;
lambda = 0.0609;
B = [ones(size(tau,2),1), ((1-exp(-lambda*tau))./(lambda*tau))',...
    ((1-exp(-lambda*tau))./(lambda*tau) - exp(-lambda*tau))'];
beta0 = [1, -1, 1]';


%% Simulate from Dynamic Nelson-Siegel dgp
[yields_sim, betas_sim] = dgpDNS(beta0, B, c, phi, var1, sigma, R, T, tau);

%% DGP Function
function[yieldsEst, betasEst] = dgpDNS(beta0, B, c, phi, var1, sigma, R, T, tau)
[~,n] = size(phi);
var2 = sigma*eye(n);
yieldsEst = nan(T, size(B,1) , R);
betasEst = nan(T,size(B,2),R);
y = zeros(size(tau));

for r = 1:R
    beta = beta0;
    for t = 1:T
        % Simulate error terms
         nu = mvnrnd(zeros(n, 1), var2)';   % correlated nu
%         nu = normrnd(0,sqrt(sigma),n,1);   % uncorrelated nu

        % Evaluate DNS dynamics
        var_y = var1;
        for i = 1:size(tau,2)
            eps = normrnd(0, sqrt(var_y));
            y(i) = B(i,:)*beta + eps;
            var_y = 0.9*var_y;
        end
        beta = c + phi*beta + nu;
        yieldsEst(t, :, r) = y;
        betasEst(t, :, r) = beta';
    end
end
end