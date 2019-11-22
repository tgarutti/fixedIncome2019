%% Data Generating Process

%% Define initial parameters
T = 100;
R = 10;
c = [-0.023; 0.0193; -0.0163];
phi = [1.62, 29.20, 28.57;
       -0.81, -31.83, -32.00;
       0.81, 32.55, 32.72];
var1 = 0.03;
sigma = 0.1;


% DNS values
tau = [3, 6, 9, 12, 24, 36, 48, 60, 84, 120]/12;
lambda = 0.0609;
B = [ones(size(tau,2),1), ((1-exp(-lambda*tau))./(lambda*tau))',...
    ((1-exp(-lambda*tau))./(lambda*tau) - exp(-lambda*tau))'];
beta0 = [7, -7, 7]';


%% Simulate from Dynamic Nelson-Siegel dgp
sim = dgpDNS(beta0, B, c, phi, var1, sigma, R, T, tau);

%% DGP Function
function[parameterEst] = dgpDNS(beta0, B, c, phi, var1, sigma, R, T, tau)
[~,n] = size(phi);
var2 = sigma*eye(n);
parameterEst = zeros(R, T, size(B,1) + size(B,2));
y = zeros(size(tau));

for r = 1:R
    beta = beta0;
    for t = 1:T
        % Simulate error terms
        nu = mvnrnd(zeros(size(var2,2), 1), var2)';
        
        % Evaluate DNS dynamics
        for i = 1:size(tau,2)
            eps = normrnd(0, var1);
            y(i) = B(i,:)*beta + eps;
            var1 = 0.8*var1;
        end
        beta = c + phi*beta + nu;
        parameterEst(r, t, :) = [y, beta'];
    end
end
end